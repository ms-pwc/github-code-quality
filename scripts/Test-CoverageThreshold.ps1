[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$CoverageFile,

    [ValidateRange(0, 100)]
    [decimal]$MinimumPercent = 80
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if (-not (Test-Path -LiteralPath $CoverageFile -PathType Leaf)) {
    throw "Coverage report was not found: $CoverageFile"
}

[xml]$coverage = Get-Content -LiteralPath $CoverageFile -Raw
$lineRateText = $coverage.coverage.'line-rate'
if ([string]::IsNullOrWhiteSpace($lineRateText)) {
    throw "The Cobertura report does not contain coverage/@line-rate."
}

$lineRate = [decimal]::Parse(
    $lineRateText,
    [Globalization.NumberStyles]::Number,
    [Globalization.CultureInfo]::InvariantCulture
)
$actualPercent = [math]::Round($lineRate * 100, 2)

Write-Host "Line coverage: $actualPercent% (required: $MinimumPercent%)"
if ($actualPercent -lt $MinimumPercent) {
    Write-Error "Coverage gate failed: $actualPercent% is below $MinimumPercent%."
    exit 1
}

Write-Host "Coverage gate passed."