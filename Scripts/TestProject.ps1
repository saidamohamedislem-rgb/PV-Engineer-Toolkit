Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "          PV ENGINEER TOOLKIT - TESTS"
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$ErrorsFound = $false

function Test-RequiredFile {
    param([string]$Path)

    if (Test-Path $Path) {
        Write-Host "[OK] File exists: $Path" -ForegroundColor Green
    }
    else {
        Write-Host "[ERROR] Missing file: $Path" -ForegroundColor Red
        $script:ErrorsFound = $true
    }
}

function Test-JsonFile {
    param([string]$Path)

    try {
        $content = Get-Content $Path -Raw | ConvertFrom-Json
        Write-Host "[OK] JSON valid: $Path" -ForegroundColor Green
        return $content
    }
    catch {
        Write-Host "[ERROR] Invalid JSON: $Path" -ForegroundColor Red
        $script:ErrorsFound = $true
        return $null
    }
}

function Test-PowerShellSyntax {
    param([string]$Path)

    $tokens = $null
    $parseErrors = $null

    [System.Management.Automation.Language.Parser]::ParseFile(
        $Path,
        [ref]$tokens,
        [ref]$parseErrors
    ) | Out-Null

    if ($parseErrors.Count -eq 0) {
        Write-Host "[OK] PowerShell syntax valid: $Path" -ForegroundColor Green
    }
    else {
        Write-Host "[ERROR] PowerShell syntax error: $Path" -ForegroundColor Red
        $parseErrors | ForEach-Object { Write-Host $_.Message -ForegroundColor Red }
        $script:ErrorsFound = $true
    }
}

Test-RequiredFile "Data/modules.json"
Test-RequiredFile "Data/inverters.json"
Test-RequiredFile "Scripts/PVToolkit.ps1"
Test-RequiredFile "Scripts/GenerateReport.ps1"

$modules = Test-JsonFile "Data/modules.json"
$inverters = Test-JsonFile "Data/inverters.json"

Test-PowerShellSyntax "Scripts/PVToolkit.ps1"
Test-PowerShellSyntax "Scripts/GenerateReport.ps1"

if ($modules -ne $null -and $modules.Count -gt 0) {
    Write-Host "[OK] Module database contains $($modules.Count) module(s)" -ForegroundColor Green
}
else {
    Write-Host "[ERROR] Module database is empty" -ForegroundColor Red
    $ErrorsFound = $true
}

if ($inverters -ne $null -and $inverters.Count -gt 0) {
    Write-Host "[OK] Inverter database contains $($inverters.Count) inverter(s)" -ForegroundColor Green
}
else {
    Write-Host "[ERROR] Inverter database is empty" -ForegroundColor Red
    $ErrorsFound = $true
}

Write-Host ""

if ($ErrorsFound) {
    Write-Host "Tests failed." -ForegroundColor Red
    exit 1
}
else {
    Write-Host "All tests passed successfully." -ForegroundColor Green
    exit 0
}
