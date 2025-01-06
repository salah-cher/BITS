# Define the root registry paths to search
$rootPaths = @("HKLM:\SYSTEM\CurrentControlSet\Services\BITS", "HKLM:\Software\Policies\Microsoft\Windows\BITS")

# Function to search registry keys and values
function Search-Registry {
    param (
        [string]$Path
    )
    try {
        # Get all subkeys
        $subKeys = Get-ChildItem -Path $Path -Recurse -ErrorAction Stop
        foreach ($subKey in $subKeys) {
            # Get all properties (values) of the subkey
            $properties = Get-ItemProperty -Path $subKey.PSPath
            $properties.PSObject.Properties | ForEach-Object {
                [PSCustomObject]@{
                    Path  = $subKey.PSPath
                    Name  = $_.Name
                    Value = $_.Value
                }
            }
        }
    } catch {
        Write-Error "Failed to access registry path: $Path"
    }
}

# Search each root path
foreach ($rootPath in $rootPaths) {
    Search-Registry -Path $rootPath
}
