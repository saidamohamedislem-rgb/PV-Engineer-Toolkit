Clear-Host

$Version = "0.1"

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

do {

    Show-Menu

    $choice = Read-Host "Select"

    switch ($choice) {

        "1" {
            Write-Host ""
            Write-Host "Module Calculator coming soon..."
            Pause
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
            exit
        }

        Default {
            Write-Host ""
            Write-Host "Invalid option." -ForegroundColor Red
            Pause
        }
    }

} while ($true)

