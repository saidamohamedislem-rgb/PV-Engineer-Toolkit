$Root = Split-Path -Parent $PSScriptRoot
$Reports = Join-Path $Root "Reports"

if (!(Test-Path $Reports)) {
    New-Item -ItemType Directory -Path $Reports | Out-Null
}

function Read-Report {
    param([string]$FileName)

    $Path = Join-Path $Reports $FileName

    if (Test-Path $Path) {
        return Get-Content $Path -Raw
    }

    return "Missing report file: $FileName"
}

$ModuleReport = Read-Report "module-calculation.txt"
$StringReport = Read-Report "string-design.txt"
$InverterReport = Read-Report "inverter-selection.txt"

$Date = Get-Date -Format "yyyy-MM-dd HH:mm"
$Output = Join-Path $Reports "PV_Project_Report.md"

$Content = @()
$Content += "# PV Engineer Toolkit - Project Report"
$Content += ""
$Content += "Author: Mohamed Islem Saida"
$Content += "Generated: $Date"
$Content += ""
$Content += "## Project Objective"
$Content += "This project demonstrates a PowerShell-based workflow for photovoltaic engineering calculations."
$Content += ""
$Content += "## Engineering Workflow"
$Content += "1. PV module calculation"
$Content += "2. String design"
$Content += "3. Inverter selection"
$Content += "4. Automatic report generation"
$Content += ""
$Content += "## 1. Module Calculation"
$Content += $ModuleReport
$Content += ""
$Content += "## 2. String Design"
$Content += $StringReport
$Content += ""
$Content += "## 3. Inverter Selection"
$Content += $InverterReport
$Content += ""
$Content += "## Portfolio Relevance"
$Content += "This portfolio project demonstrates photovoltaic engineering logic, structured documentation and automation with PowerShell."

$Content | Set-Content $Output -Encoding UTF8

Write-Host ""
Write-Host "Report generated successfully:" -ForegroundColor Green
Write-Host $Output -ForegroundColor Yellow
Write-Host ""

Start-Process notepad.exe $Output
