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
