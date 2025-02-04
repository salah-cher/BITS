# Define the service name you want to check
$serviceName = "SECURA" # Replace with the name of your service

Write-Output "Checking if the service '$serviceName' is installed..."

# Check if Secura is installed
$CheckSecura = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
If ($CheckSecura) {
    Write-Output "Service '$serviceName' is still present, skipping remediation."
} else {
    Write-Output "Service '$serviceName' is not present. Starting remediation process..."

    # Define the registry key paths to check and remove
    $regKeyPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Services\SECURA",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($regKeyPath in $regKeyPaths) {
        Write-Output "Checking registry path: '$regKeyPath'..."

        if ($regKeyPath -like "*\*") {
            # Handle wildcard paths (e.g., Uninstall\*)
            $subKeys = Get-ChildItem -Path $regKeyPath -ErrorAction SilentlyContinue
            if ($subKeys) {
                foreach ($subKey in $subKeys) {
                    if ($subKey.PSChildName -like "*SECURA*") {
                        Write-Output "Found registry subkey: $($subKey.PSPath)"
                        try {
                            # Remove the registry subkey
                            Remove-Item -Path $subKey.PSPath -Recurse -Force
                            Write-Output "Removed registry subkey: $($subKey.PSPath)"
                        } catch {
                            Write-Warning "Failed to remove registry subkey: $($subKey.PSPath) - $($_.Exception.Message)"
                        }
                    } else {
                        Write-Output "No matching subkey found for 'SECURA' in: $($subKey.PSPath)"
                    }
                }
            } else {
                Write-Output "No subkeys found under: $regKeyPath"
            }
        } else {
            # Handle specific paths
            if (Test-Path $regKeyPath) {
                Write-Output "Found registry key: $regKeyPath"
                try {
                    # Remove the registry key
                    Remove-Item -Path $regKeyPath -Recurse -Force
                    Write-Output "Removed registry key: $regKeyPath"
                } catch {
                    Write-Warning "Failed to remove registry key: $regKeyPath - $($_.Exception.Message)"
                }
            } else {
                Write-Output "Registry key does not exist: $regKeyPath"
            }
        }
    }
    Write-Output "Registry key removal process completed."
}
