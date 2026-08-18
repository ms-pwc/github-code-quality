[CmdletBinding()]
param(
    [string]$HostUrl = "http://localhost:9000",
    [string]$ProjectKey = "github-code-quality-poc",
    [string]$ProjectName = "GitHub Code Quality Comparison POC",
    [string]$GateName = "POC - SonarQube vs GitHub"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$token = $env:SONAR_ADMIN_TOKEN
if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Set SONAR_ADMIN_TOKEN to a SonarQube user token with project and quality-gate administration permissions."
}

$HostUrl = $HostUrl.TrimEnd("/")
$basicToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${token}:"))
$headers = @{ Authorization = "Basic $basicToken" }

function Invoke-SonarGet {
    param([Parameter(Mandatory)][string]$Path)
    Invoke-RestMethod -Method Get -Uri "$HostUrl$Path" -Headers $headers
}

function Invoke-SonarPost {
    param(
        [Parameter(Mandatory)][string]$Path,
        [hashtable]$Body = @{}
    )
    Invoke-RestMethod -Method Post -Uri "$HostUrl$Path" -Headers $headers -Body $Body
}

$status = Invoke-SonarGet -Path "/api/system/status"
if ($status.status -ne "UP") {
    throw "SonarQube is not ready. Current status: $($status.status)"
}

$projectSearch = Invoke-SonarGet -Path "/api/projects/search?projects=$([Uri]::EscapeDataString($ProjectKey))"
if ($projectSearch.components.Count -eq 0) {
    $null = Invoke-SonarPost -Path "/api/projects/create" -Body @{
        project = $ProjectKey
        name = $ProjectName
        visibility = "public"
    }
    Write-Host "Created SonarQube project '$ProjectKey'."
}
else {
    Write-Host "SonarQube project '$ProjectKey' already exists."
}

$gates = Invoke-SonarGet -Path "/api/qualitygates/list"
$gate = $gates.qualitygates | Where-Object { $_.name -eq $GateName } | Select-Object -First 1
if ($null -eq $gate) {
    $null = Invoke-SonarPost -Path "/api/qualitygates/create" -Body @{ name = $GateName }
    Write-Host "Created quality gate '$GateName'."
}
else {
    Write-Host "Quality gate '$GateName' already exists."
}

$conditions = @(
    @{ metric = "reliability_rating"; op = "GT"; error = "1" },
    @{ metric = "security_rating"; op = "GT"; error = "1" },
    @{ metric = "coverage"; op = "LT"; error = "80" },
    @{ metric = "duplicated_lines_density"; op = "GT"; error = "3" },
    @{ metric = "security_hotspots_reviewed"; op = "LT"; error = "100" },
    @{ metric = "violations"; op = "GT"; error = "0" },
    @{ metric = "new_reliability_rating"; op = "GT"; error = "1" },
    @{ metric = "new_security_rating"; op = "GT"; error = "1" },
    @{ metric = "new_maintainability_rating"; op = "GT"; error = "1" },
    @{ metric = "new_coverage"; op = "LT"; error = "80" },
    @{ metric = "new_duplicated_lines_density"; op = "GT"; error = "3" },
    @{ metric = "new_security_hotspots_reviewed"; op = "LT"; error = "100" }
)

$gateDetails = Invoke-SonarGet -Path "/api/qualitygates/show?name=$([Uri]::EscapeDataString($GateName))"
$existingMetrics = @($gateDetails.conditions | ForEach-Object { $_.metric })
foreach ($condition in $conditions) {
    if ($existingMetrics -contains $condition.metric) {
        continue
    }

    try {
        $null = Invoke-SonarPost -Path "/api/qualitygates/create_condition" -Body @{
            gateName = $GateName
            metric = $condition.metric
            op = $condition.op
            error = $condition.error
        }
        Write-Host "Added quality-gate condition '$($condition.metric)'."
    }
    catch {
        Write-Warning "Could not add gate condition '$($condition.metric)'. The installed edition/version may not expose that metric: $($_.Exception.Message)"
    }
}

$null = Invoke-SonarPost -Path "/api/qualitygates/select" -Body @{
    gateName = $GateName
    projectKey = $ProjectKey
}

Write-Host "Assigned quality gate '$GateName' to '$ProjectKey'."
Write-Host "Project URL: $HostUrl/dashboard?id=$([Uri]::EscapeDataString($ProjectKey))"