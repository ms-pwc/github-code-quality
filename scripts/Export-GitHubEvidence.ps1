[CmdletBinding()]
param(
    [string]$Repository = "ms-pwc/github-code-quality",
    [string]$Branch = "github-native-poc",
    [int]$PullRequest = 1,
    [string]$OutputDirectory = "docs/evidence/github"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI is required. Install it and authenticate with 'gh auth login'."
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path $repositoryRoot $OutputDirectory
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

function Save-GitHubResponse {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Endpoint,
        [switch]$AllowUnavailable
    )
    $response = gh api $Endpoint 2>&1
    if ($LASTEXITCODE -ne 0) {
        if ($AllowUnavailable) {
            Write-Warning "GitHub endpoint is unavailable and was not exported: $Endpoint"
            return
        }
        throw "GitHub API request failed: $Endpoint"
    }
    $response | Set-Content -Path (Join-Path $outputPath "$Name.json") -Encoding utf8
}

$encodedRef = [Uri]::EscapeDataString("refs/heads/$Branch")
Save-GitHubResponse -Name "code-quality-setup" -Endpoint "repos/$Repository/code-quality/setup"
Save-GitHubResponse -Name "code-quality-findings" -Endpoint "repos/$Repository/code-quality/findings?per_page=100&state=open"
Save-GitHubResponse -Name "code-scanning-alerts" -Endpoint "repos/$Repository/code-scanning/alerts?per_page=100&state=open&ref=$encodedRef"
Save-GitHubResponse -Name "rulesets" -Endpoint "repos/$Repository/rulesets?includes_parents=true"
Save-GitHubResponse -Name "workflow-runs" -Endpoint "repos/$Repository/actions/runs?branch=$Branch&per_page=100"
Save-GitHubResponse -Name "dependabot-alerts" -Endpoint "repos/$Repository/dependabot/alerts?per_page=100&state=open" -AllowUnavailable
Save-GitHubResponse -Name "secret-scanning-alerts" -Endpoint "repos/$Repository/secret-scanning/alerts?per_page=100&state=open" -AllowUnavailable

$rulesetSummaries = gh api "repos/$Repository/rulesets?includes_parents=true" | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw "Could not read repository rulesets." }
$rulesetDetails = @(
    foreach ($ruleset in $rulesetSummaries) {
        gh api "repos/$Repository/rulesets/$($ruleset.id)" | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0) { throw "Could not read ruleset $($ruleset.id)." }
    }
)
$rulesetDetails | ConvertTo-Json -Depth 30 | Set-Content -Path (Join-Path $outputPath "ruleset-details.json") -Encoding utf8

if ($PullRequest -gt 0) {
    Save-GitHubResponse -Name "pull-request" -Endpoint "repos/$Repository/pulls/$PullRequest"
    Save-GitHubResponse -Name "pull-request-comments" -Endpoint "repos/$Repository/issues/$PullRequest/comments?per_page=100"
    Save-GitHubResponse -Name "pull-request-review-comments" -Endpoint "repos/$Repository/pulls/$PullRequest/comments?per_page=100"

    $pullRequestData = gh api "repos/$Repository/pulls/$PullRequest" | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw "Could not read pull request $PullRequest." }
    Save-GitHubResponse -Name "pull-request-check-runs" -Endpoint "repos/$Repository/commits/$($pullRequestData.head.sha)/check-runs?per_page=100"
}

$repositoryState = gh api "repos/$Repository" --jq '{security_and_analysis,default_branch,visibility}'
if ($LASTEXITCODE -ne 0) { throw "Could not read repository security state." }
$repositoryState | Set-Content -Path (Join-Path $outputPath "repository-security.json") -Encoding utf8

@{
    capturedAtUtc = [DateTime]::UtcNow.ToString("o")
    repository = $Repository
    branch = $Branch
    pullRequest = $PullRequest
    sourceRevision = (git -C $repositoryRoot rev-parse HEAD)
} | ConvertTo-Json | Set-Content -Path (Join-Path $outputPath "metadata.json") -Encoding utf8

Write-Host "Saved GitHub API evidence to '$outputPath'."