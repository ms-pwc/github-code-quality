[CmdletBinding()]
param(
    [string]$HostUrl = "http://localhost:9000",
    [string]$ProjectKey = "github-code-quality-poc",
    [string]$OutputDirectory = "docs/evidence/sonarqube"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$token = $env:SONAR_TOKEN
if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Set SONAR_TOKEN before exporting SonarQube evidence."
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path $repositoryRoot $OutputDirectory
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$basicToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${token}:"))
$headers = @{ Authorization = "Basic $basicToken" }
$HostUrl = $HostUrl.TrimEnd("/")
$encodedProject = [Uri]::EscapeDataString($ProjectKey)

function Save-SonarResponse {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Path
    )
    $response = Invoke-RestMethod -Method Get -Uri "$HostUrl$Path" -Headers $headers
    $response | ConvertTo-Json -Depth 30 | Set-Content -Path (Join-Path $outputPath "$Name.json") -Encoding utf8
}

$metrics = @(
    "alert_status",
    "bugs",
    "reliability_rating",
    "vulnerabilities",
    "security_rating",
    "security_hotspots",
    "security_hotspots_reviewed",
    "code_smells",
    "sqale_rating",
    "sqale_index",
    "coverage",
    "lines_to_cover",
    "uncovered_lines",
    "duplicated_lines_density",
    "duplicated_blocks",
    "complexity",
    "cognitive_complexity",
    "ncloc"
) -join ","

Save-SonarResponse -Name "measures" -Path "/api/measures/component?component=$encodedProject&metricKeys=$metrics"
Save-SonarResponse -Name "quality-gate" -Path "/api/qualitygates/project_status?projectKey=$encodedProject"
Save-SonarResponse -Name "issues" -Path "/api/issues/search?componentKeys=$encodedProject&ps=500&additionalFields=_all"

try {
    Save-SonarResponse -Name "security-hotspots" -Path "/api/hotspots/search?projectKey=$encodedProject&ps=500"
}
catch {
    Write-Warning "Security hotspot export was not available: $($_.Exception.Message)"
}

@{
    capturedAtUtc = [DateTime]::UtcNow.ToString("o")
    hostUrl = $HostUrl
    projectKey = $ProjectKey
    sourceRevision = (git -C $repositoryRoot rev-parse HEAD)
} | ConvertTo-Json | Set-Content -Path (Join-Path $outputPath "metadata.json") -Encoding utf8

Write-Host "Saved sanitized SonarQube API evidence to '$outputPath'."