Clear-Host

$Version = "0.2"
$RootPath = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ModuleDatabasePath = Join-Path $RootPath "Data\modules.json"
$ReportsPath = Join-Path $RootPath "Reports"

function Convert-ToNumber {
    param(
        [string]$Value
    )

    $cleanValue = $Value.Replace(",", ".")

    return [double]::Parse(
        $cleanValue,
        [System.Globalization.CultureInfo]::InvariantCulture
    )
}

function Load-PVModules {

    if (-not (Test-Path $ModuleDatabasePath)) {
        Write-Host "Module database not found: $ModuleDatabasePath" -ForegroundColor Red
        Pause
        return $null
    }

    $modules = Get-Content $ModuleDatabasePath -Raw | ConvertFrom-Json
    return $modules
}

function Show-Menu {

    Clear-Host

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "         PV ENGINEER TOOLKIT  v$Version"
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "1  Module Calculator"
    Write-Host "2  String Designer"
    Write-Host "3  Voltage Calculator"
    Write-Host "4  Inverter Selector"
    Write-Host "5  Cable Calculator"
    Write-Host "6  Energy Yield"
    Write-Host "7  Generate Report"
    Write-Host "8  Settings"
    Write-Host ""
    Write-Host "0  Exit"
    Write-Host ""
}

function Show-ModuleCalculator {

    Clear-Host

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "              MODULE CALCULATOR"
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""

    $modules = Load-PVModules

    if ($null -eq $modules) {
        return
    }

    Write-Host "Available PV modules:"
    Write-Host ""

    for ($i = 0; $i -lt $modules.Count; $i++) {
        $number = $i + 1
        Write-Host "$number - $($modules[$i].Name) | $($modules[$i].Power) W"
    }

    Write-Host ""

    $targetInput = Read-Host "Target PV power in kWp"
    $targetPowerKWp = Convert-ToNumber $targetInput

    $moduleChoice = Read-Host "Select module number"
    $selectedModule = $modules[[int]$moduleChoice - 1]

    $requiredModules = [math]::Ceiling(($targetPowerKWp * 1000) / $selectedModule.Power)
    $installedPowerKWp = [math]::Round(($requiredModules * $selectedModule.Power) / 1000, 2)

    Clear-Host

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "              CALCULATION RESULT"
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""

    Write-Host "Target power:        $targetPowerKWp kWp"
    Write-Host "Selected module:     $($selectedModule.Name)"
    Write-Host "Module power:        $($selectedModule.Power) W"
    Write-Host "Required modules:    $requiredModules"
    Write-Host "Installed DC power:  $installedPowerKWp kWp"
    Write-Host ""

    Write-Host "Module electrical data:"
    Write-Host "Voc:                 $($selectedModule.Voc) V"
    Write-Host "Vmp:                 $($selectedModule.Vmp) V"
    Write-Host "Imp:                 $($selectedModule.Imp) A"
    Write-Host "Isc:                 $($selectedModule.Isc) A"
    Write-Host ""

    if (-not (Test-Path $ReportsPath)) {
        New-Item -ItemType Directory -Path $ReportsPath | Out-Null
    }

    $reportFile = Join-Path $ReportsPath "module-calculation.txt"

    @"
PV Engineer Toolkit - Module Calculation

Target power:       $targetPowerKWp kWp
Selected module:    $($selectedModule.Name)
Module power:       $($selectedModule.Power) W
Required modules:   $requiredModules
Installed DC power: $installedPowerKWp kWp

Electrical data:
Voc: $($selectedModule.Voc) V
Vmp: $($selectedModule.Vmp) V
Imp: $($selectedModule.Imp) A
Isc: $($selectedModule.Isc) A
"@ | Set-Content $reportFile

    Write-Host "Report saved to: $reportFile" -ForegroundColor Yellow
    Write-Host ""

    Pause
}

do {

    Show-Menu

    $choice = Read-Host "Select"

    switch ($choice) {

        "1" {
            Show-ModuleCalculator
        }

        "2" {
            Write-Host ""
            Write-Host "String Designer coming soon..."
            Pause
        }

        "3" {
            Write-Host ""
            Write-Host "Voltage Calculator coming soon..."
            Pause
        }

        "4" {
            Write-Host ""
            Write-Host "Inverter Selector coming soon..."
            Pause
        }

        "5" {
            Write-Host ""
            Write-Host "Cable Calculator coming soon..."
            Pause
        }

        "6" {
            Write-Host ""
            Write-Host "Energy Yield coming soon..."
            Pause
        }

        "7" {
            Write-Host ""
            Write-Host "Generate Report coming soon..."
            Pause
        }

        "8" {
            Write-Host ""
            Write-Host "Settings coming soon..."
            Pause
        }

        "0" {
            Write-Host ""
            Write-Host "Goodbye!" -ForegroundColor Green
            return
        }

        Default {
            Write-Host ""
            Write-Host "Invalid option." -ForegroundColor Red
            Pause
        }
    }

} while ($true)
