[CmdletBinding()]
param(
    [string]$HostUrl = "http://localhost:9000",
    [string]$ProjectKey = "github-code-quality-poc",
    [string]$ProjectName = "GitHub Code Quality Comparison POC",
    [string]$ProjectVersion = "1.0",
    [switch]$SkipQualityGateWait
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$token = $env:SONAR_TOKEN
if ([string]::IsNullOrWhiteSpace($token)) {
    throw "Set SONAR_TOKEN to a project-analysis token. Never commit the token."
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repositoryRoot

$coverageDirectory = Join-Path $repositoryRoot "artifacts/sonarqube"
$coveragePrefix = Join-Path $coverageDirectory "coverage"
$coveragePath = "$coveragePrefix.opencover.xml"
New-Item -ItemType Directory -Path $coverageDirectory -Force | Out-Null

Write-Host "Restoring the pinned SonarScanner for .NET tool."
dotnet tool restore --configfile NuGet.config
if ($LASTEXITCODE -ne 0) { throw "dotnet tool restore failed with exit code $LASTEXITCODE." }

dotnet clean CodeQualityPoc.sln --configuration Release --verbosity minimal
if ($LASTEXITCODE -ne 0) { throw "dotnet clean failed with exit code $LASTEXITCODE." }

$beginArguments = @(
    "sonarscanner",
    "begin",
    "/k:$ProjectKey",
    "/n:$ProjectName",
    "/v:$ProjectVersion",
    "/d:sonar.host.url=$($HostUrl.TrimEnd('/'))",
    "/d:sonar.token=$token",
    "/d:sonar.cs.opencover.reportsPaths=$coveragePath",
    "/d:sonar.cs.vstest.reportsPaths=**/TestResults/*.trx",
    "/d:sonar.exclusions=**/bin/**,**/obj/**,artifacts/**",
    "/d:sonar.coverage.exclusions=**/Program.cs",
    "/d:sonar.scm.provider=git",
    "/d:sonar.qualitygate.wait=$(!$SkipQualityGateWait)",
    "/d:sonar.qualitygate.timeout=300"
)

Write-Host "Beginning SonarQube analysis for '$ProjectKey'."
& dotnet @beginArguments
if ($LASTEXITCODE -ne 0) { throw "SonarScanner begin failed with exit code $LASTEXITCODE." }

dotnet build CodeQualityPoc.sln --configuration Release --no-incremental --disable-build-servers
if ($LASTEXITCODE -ne 0) { throw "dotnet build failed with exit code $LASTEXITCODE." }

dotnet test tests/QualityDemo.Tests/QualityDemo.Tests.csproj `
    --configuration Release `
    --no-build `
    --logger "trx;LogFileName=sonarqube-tests.trx" `
    /p:CollectCoverage=true `
    "/p:CoverletOutput=$coveragePrefix" `
    /p:CoverletOutputFormat=opencover
if ($LASTEXITCODE -ne 0) { throw "dotnet test failed with exit code $LASTEXITCODE." }

Write-Host "Uploading analysis to SonarQube. A non-zero result is expected when the quality gate fails on the deliberate defects."
& dotnet sonarscanner end "/d:sonar.token=$token"
$scannerExitCode = $LASTEXITCODE

Write-Host "Dashboard: $($HostUrl.TrimEnd('/'))/dashboard?id=$([Uri]::EscapeDataString($ProjectKey))"
exit $scannerExitCode