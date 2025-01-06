# BITS Configuration PowerShell Scripts

This repository contains two PowerShell scripts to help manage and troubleshoot Background Intelligent Transfer Service (BITS) settings in the Windows registry.

## Scripts

### 1. Search for BITS Configurations

This script searches for all registry configurations related to BITS across multiple registry hives.

#### Usage

```powershell
# Define the registry hives to search
$hives = @("HKLM:\SYSTEM", "HKLM:\SOFTWARE", "HKCU:\Software", "HKU:\", "HKCR:\")

# Function to search registry keys and values
function Search-Registry {
    param (
        [string]$Path
    )
    try {
        # Get all subkeys
        $subKeys = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue
        foreach ($subKey in $subKeys) {
            # Get all properties (values) of the subkey
            $properties = Get-ItemProperty -Path $subKey.PSPath -ErrorAction SilentlyContinue
            $properties.PSObject.Properties | ForEach-Object {
                if ($_.Name -match "BITS") {
                    [PSCustomObject]@{
                        Path  = $subKey.PSPath
                        Name  = $_.Name
                        Value = $_.Value
                    }
                }
            }
        }
    } catch {
        Write-Error "Failed to access registry path: $Path"
    }
}

# Search each hive
foreach ($hive in $hives) {
    Search-Registry -Path $hive
}
```

### 2. Set BITS Start Value

This script sets the `Start` value for the BITS service to `2` (Automatic) to ensure it starts automatically with the system.

#### Usage

```powershell
# Change the Start value for BITS to Automatic
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\BITS" -Name "Start" -Value 2
```

## Explanation

### Search for BITS Configurations

- **$hives**: Specifies the main registry hives to search, including `HKLM:\SYSTEM`, `HKLM:\SOFTWARE`, `HKCU:\Software`, `HKU:\`, and `HKCR:\`.
- **Search-Registry Function**: Recursively searches each specified registry path for subkeys and their properties (values) that match "BITS".
- **Get-ChildItem**: Retrieves all subkeys under the specified path.
- **Get-ItemProperty**: Retrieves all properties (values) of each subkey.
- **Match "BITS"**: Filters properties to include only those related to BITS.

### Set BITS Start Value

- **Set-ItemProperty**: Changes the `Start` value for the BITS service to `2` (Automatic), ensuring that BITS starts automatically with the system.

## Notes

- Ensure you run these scripts with administrative privileges to access and modify the registry.
- Use these scripts with caution, as incorrect modifications to the registry can impact system stability.
