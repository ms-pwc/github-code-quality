[CmdletBinding()]
param(
    [string]$Repository = "ms-pwc/github-code-quality",
    [string]$Branch = "github-native-poc",
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
        [Parameter(Mandatory)][string]$Endpoint
    )
    $response = gh api --paginate $Endpoint
    if ($LASTEXITCODE -ne 0) {
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

$repositoryState = gh api "repos/$Repository" --jq '{security_and_analysis,default_branch,visibility}'
if ($LASTEXITCODE -ne 0) { throw "Could not read repository security state." }
$repositoryState | Set-Content -Path (Join-Path $outputPath "repository-security.json") -Encoding utf8

@{
    capturedAtUtc = [DateTime]::UtcNow.ToString("o")
    repository = $Repository
    branch = $Branch
    sourceRevision = (git -C $repositoryRoot rev-parse HEAD)
} | ConvertTo-Json | Set-Content -Path (Join-Path $outputPath "metadata.json") -Encoding utf8

Write-Host "Saved GitHub API evidence to '$outputPath'."