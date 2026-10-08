Clear-Host

$Version = "0.3"
$RootPath = Split-Path -Parent $PSScriptRoot
$ModuleDatabasePath = Join-Path $RootPath "Data\modules.json"
$ReportsPath = Join-Path $RootPath "Reports"

function Convert-ToNumber {
    param([string]$Value)

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

    return Get-Content $ModuleDatabasePath -Raw | ConvertFrom-Json
}

function Select-PVModule {

    $modules = Load-PVModules

    if ($null -eq $modules) {
        return $null
    }

    Write-Host "Available PV modules:"
    Write-Host ""

    for ($i = 0; $i -lt $modules.Count; $i++) {
        $number = $i + 1
        Write-Host "$number - $($modules[$i].Name) | $($modules[$i].Power) W"
    }

    Write-Host ""

    $moduleChoice = [int](Read-Host "Select module number")

    if ($moduleChoice -lt 1 -or $moduleChoice -gt $modules.Count) {
        Write-Host "Invalid module selection." -ForegroundColor Red
        Pause
        return $null
    }

    return $modules[$moduleChoice - 1]
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

    $selectedModule = Select-PVModule

    if ($null -eq $selectedModule) {
        return
    }

    Write-Host ""

    $targetInput = Read-Host "Target PV power in kWp"
    $targetPowerKWp = Convert-ToNumber $targetInput

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

function Show-StringDesigner {

    Clear-Host

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "               STRING DESIGNER"
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""

    $selectedModule = Select-PVModule

    if ($null -eq $selectedModule) {
        return
    }

    Write-Host ""

    $targetInput = Read-Host "Target PV power in kWp"
    $targetPowerKWp = Convert-ToNumber $targetInput

    $maxDcInput = Read-Host "Inverter maximum DC voltage in V [1000]"

    if ([string]::IsNullOrWhiteSpace($maxDcInput)) {
        $maxDcVoltage = 1000
    }
    else {
        $maxDcVoltage = Convert-ToNumber $maxDcInput
    }

    $requiredModules = [math]::Ceiling(($targetPowerKWp * 1000) / $selectedModule.Power)
    $installedPowerKWp = [math]::Round(($requiredModules * $selectedModule.Power) / 1000, 2)

    $maxModulesPerString = [math]::Floor($maxDcVoltage / $selectedModule.Voc)

    if ($maxModulesPerString -lt 1) {
        Write-Host "Error: Inverter voltage is too low for this module." -ForegroundColor Red
        Pause
        return
    }

    $stringsNeeded = [math]::Ceiling($requiredModules / $maxModulesPerString)

    $baseModulesPerString = [math]::Floor($requiredModules / $stringsNeeded)
    $extraStrings = $requiredModules % $stringsNeeded

    $highStringModules = $baseModulesPerString + 1

    $baseVoc = [math]::Round($baseModulesPerString * $selectedModule.Voc, 2)
    $baseVmp = [math]::Round($baseModulesPerString * $selectedModule.Vmp, 2)

    $highVoc = [math]::Round($highStringModules * $selectedModule.Voc, 2)
    $highVmp = [math]::Round($highStringModules * $selectedModule.Vmp, 2)

    Clear-Host

    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "              STRING DESIGN RESULT"
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""

    Write-Host "Target power:              $targetPowerKWp kWp"
    Write-Host "Selected module:           $($selectedModule.Name)"
    Write-Host "Module power:              $($selectedModule.Power) W"
    Write-Host "Required modules:          $requiredModules"
    Write-Host "Installed DC power:        $installedPowerKWp kWp"
    Write-Host ""
    Write-Host "Inverter max DC voltage:   $maxDcVoltage V"
    Write-Host "Module Voc:                $($selectedModule.Voc) V"
    Write-Host "Maximum modules/string:    $maxModulesPerString"
    Write-Host "Required strings:          $stringsNeeded"
    Write-Host ""

    Write-Host "Proposed string layout:"
    Write-Host ""

    if ($extraStrings -gt 0) {
        $normalStrings = $stringsNeeded - $extraStrings

        Write-Host "$extraStrings string(s) x $highStringModules modules"
        Write-Host "$normalStrings string(s) x $baseModulesPerString modules"
        Write-Host ""
        Write-Host "Highest string Voc:        $highVoc V"
        Write-Host "Highest string Vmp:        $highVmp V"
    }
    else {
        Write-Host "$stringsNeeded string(s) x $baseModulesPerString modules"
        Write-Host ""
        Write-Host "String Voc:                $baseVoc V"
        Write-Host "String Vmp:                $baseVmp V"
    }

    Write-Host ""

    if (-not (Test-Path $ReportsPath)) {
        New-Item -ItemType Directory -Path $ReportsPath | Out-Null
    }

    $reportFile = Join-Path $ReportsPath "string-design.txt"

    @"
PV Engineer Toolkit - String Design

Target power:             $targetPowerKWp kWp
Selected module:          $($selectedModule.Name)
Module power:             $($selectedModule.Power) W
Required modules:         $requiredModules
Installed DC power:       $installedPowerKWp kWp

Inverter max DC voltage:  $maxDcVoltage V
Module Voc:               $($selectedModule.Voc) V
Module Vmp:               $($selectedModule.Vmp) V

Maximum modules/string:   $maxModulesPerString
Required strings:         $stringsNeeded

Base modules/string:      $baseModulesPerString
Extra strings:            $extraStrings
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
            Show-StringDesigner
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
