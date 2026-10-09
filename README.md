# PV Engineer Toolkit

A PowerShell-based engineering toolkit for photovoltaic system design, DC planning and technical documentation.

## Author

Mohamed Islem Saida

## Project Goal

This project demonstrates a structured workflow for photovoltaic engineering calculations and documentation.

It was created as a personal engineering portfolio project to combine:

- Photovoltaic engineering
- Electrical calculations
- PowerShell automation
- Technical documentation
- Git/GitHub workflow

## Features

- PV module database
- Inverter database
- Module quantity calculation
- String design
- Voltage check
- Inverter selection
- DC/AC ratio check
- Automatic report generation

## Project Structure

```text
PV-Engineer-Toolkit
│
├── Data
│   ├── modules.json
│   └── inverters.json
│
├── Docs
│   ├── Project_Overview_DE.md
│   ├── STEG_Experience_DE.md
│   └── Technical_Background_DE.md
│
├── Reports
│   ├── module-calculation.txt
│   ├── string-design.txt
│   ├── inverter-selection.txt
│   └── PV_Project_Report.md
│
└── Scripts
    ├── PVToolkit.ps1
    └── GenerateReport.ps1


## Quick Start

To run the toolkit locally:

```powershell
git clone https://github.com/saidamohamedislem-rgb/PV-Engineer-Toolkit.git
cd PV-Engineer-Toolkit
Set-ExecutionPolicy -Scope Process Bypass
.\Scripts\PVToolkit.ps1

.\Scripts\GenerateReport.ps1
```

## Example Output

For a target PV power of 100 kWp using a 450 W module, the toolkit calculates:

```text
Required modules: 223
Installed DC power: 100.35 kWp
String layout: 7 strings x 19 modules + 5 strings x 18 modules
Highest string Voc: 940.5 V
```

## Note

This project is a technical prototype and not a replacement for professional PV planning software such as PV*SOL, PVcase or Sunny Design.

The current inverter data is sample data. The structure is prepared so that real manufacturer datasheets can be added later.

