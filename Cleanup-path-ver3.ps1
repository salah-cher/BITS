# Define the service name you want to Check
`$serviceName = "SECURA" # Replace with the name of your service

# Check if Secura is installed
`$CheckSecura = Get-Service -Name `$serviceName
If (`$CheckSecura) {
    Write-Output "Still present, skip remediation"
} else {
    # Remove Folders for DataCard
    `$CleanupFolders = @("C:\CMCONFIG", "C:\KEYFILE", "C:\ProgramData\Entrust", "C:\ProgramData\EntrustDataCard", "C:\Program Files\Datacard", "C:\Program Files (x86)\Acuant")
    foreach (`$folder in `$CleanupFolders) {
        # Check if the folder exists
        if (Test-Path `$folder) {
            try {
                # Remove the folder and its contents
                Remove-Item -Path `$folder -Recurse -Force
                Write-Output "Removed folder: `$folder"
            } catch {
                Write-Warning "Failed to remove folder: `$folder - `$(`$_.Exception.Message)"
            }
        } else {
            Write-Output "Folder does not exist: `$folder"
        }
    }
    Write-Output "Folder removal process completed."

    # Define the folder name to remove from each user's AppData\Roaming directory
    `$folderToRemove = "Datacard"

    # Get all user profiles from the system (excluding system profiles)
    `$userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { `$_.Special -eq `$false -and `$_.LocalPath -like "C:\Users\*" }
    foreach (`$profile in `$userProfiles) {
        # Construct the path to the folder inside each user's AppData\Roaming directory
        `$folderPath = Join-Path -Path `$profile.LocalPath -ChildPath "AppData\Roaming\`$folderToRemove"

        # Check if the folder exists
        if (Test-Path `$folderPath) {
            try {
                # Remove the folder and its contents
                Remove-Item -Path `$folderPath -Recurse -Force
                Write-Output "Removed folder: `$folderPath"
            } catch {
                Write-Warning "Failed to remove folder: `$folderPath - `$(`$_.Exception.Message)"
            }
        } else {
            Write-Output "Folder does not exist: `$folderPath"
        }
    }
    Write-Output "Cleanup process completed."

    # Define the registry key path
    `$regKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SECURA"

    # Check if the registry key exists
    if (Test-Path `$regKeyPath) {
        try {
            # Remove the registry key
            Remove-Item -Path `$regKeyPath -Recurse -Force
            Write-Output "Removed registry key: `$regKeyPath"
        } catch {
            Write-Warning "Failed to remove registry key: `$regKeyPath - `$(`$_.Exception.Message)"
        }
    } else {
        Write-Output "Registry key does not exist: `$regKeyPath"
    }
    Write-Output "Registry key removal process completed."
