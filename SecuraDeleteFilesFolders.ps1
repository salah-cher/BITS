# Define the service name you want to check
$serviceName = "SECURA" # Replace with the name of your service

Write-Output "Checking if the service '$serviceName' is installed..."

# Check if Secura is installed
$CheckSecura = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
If ($CheckSecura) {
    Write-Output "Service '$serviceName' is still present, skipping remediation."
} else {
    Write-Output "Service '$serviceName' is not present. Starting remediation process..."

    # Initialize counters
    $totalFoldersRemoved = 0
    $totalFilesRemoved = 0

    # Remove Folders for DataCard
    $CleanupFolders = @("C:\CMCONFIG", "C:\KEYFILE", "C:\ProgramData\Entrust", "C:\ProgramData\EntrustDataCard", "C:\Program Files\Datacard", "C:\Program Files (x86)\Acuant")
    foreach ($folder in $CleanupFolders) {
        Write-Output "Checking if folder '$folder' exists..."
        # Check if the folder exists
        if (Test-Path $folder) {
            try {
                # Count files and folders before removal
                $files = Get-ChildItem -Path $folder -Recurse -File -ErrorAction SilentlyContinue
                $folders = Get-ChildItem -Path $folder -Recurse -Directory -ErrorAction SilentlyContinue
                $totalFilesRemoved += $files.Count
                $totalFoldersRemoved += $folders.Count + 1 # Including the root folder

                # Remove the folder and its contents
                Remove-Item -Path $folder -Recurse -Force
                Write-Output "Removed folder: $folder"
            } catch {
                Write-Warning "Failed to remove folder: $folder - $($_.Exception.Message)"
            }
        } else {
            Write-Output "Folder does not exist: $folder"
        }
    }
    Write-Output "Folder removal process completed."

    # Define the folder name to remove from each user's AppData\Roaming directory
    $folderToRemove = "Datacard"

    Write-Output "Starting cleanup of user profiles..."

    # Get all user profiles from the system (excluding system profiles)
    $userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.LocalPath -like "C:\Users\*" }
    foreach ($profile in $userProfiles) {
        # Construct the path to the folder inside each user's AppData\Roaming directory
        $folderPath = Join-Path -Path $profile.LocalPath -ChildPath "AppData\Roaming\$folderToRemove"

        Write-Output "Checking if folder '$folderPath' exists for user profile '$($profile.LocalPath)'..."
        # Check if the folder exists
        if (Test-Path $folderPath) {
            try {
                # Count files and folders before removal
                $files = Get-ChildItem -Path $folderPath -Recurse -File -ErrorAction SilentlyContinue
                $folders = Get-ChildItem -Path $folderPath -Recurse -Directory -ErrorAction SilentlyContinue
                $totalFilesRemoved += $files.Count
                $totalFoldersRemoved += $folders.Count + 1 # Including the root folder

                # Remove the folder and its contents
                Remove-Item -Path $folderPath -Recurse -Force
                Write-Output "Removed folder: $folderPath"
            } catch {
                Write-Warning "Failed to remove folder: $folderPath - $($_.Exception.Message)"
            }
        } else {
            Write-Output "Folder does not exist: $folderPath"
        }
    }
    Write-Output "User profile cleanup process completed."

    # Output the total number of files and folders removed
    Write-Output "Total folders removed: $totalFoldersRemoved"
    Write-Output "Total files removed: $totalFilesRemoved"
}
