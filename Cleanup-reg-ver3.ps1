# Define the registry paths for 32-bit and 64-bit applications
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

Write-Output "Starting registry scan for Secura applications..."

# Loop through each registry path and retrieve the application information
foreach ($path in $registryPaths) {
    Write-Output "Scanning registry path: $path"
    Get-ItemProperty $path | ForEach-Object {
        $appName = $_.DisplayName
        $appVersion = $_.DisplayVersion

        Write-Output "Found application: $appName, Version: $appVersion"

        # Check if the application name contains "Secura" and version equals "4.00"
        if ($appName -like "*Secura*" -and $appVersion -ne "4.00") {
            Write-Output "Secura application found with version other than 4.00. Checking for scheduled task..."

            # Define the name of the scheduled task to check
            $taskName = "Secura Cleanup Standalone" # Replace with the name of your scheduled task

            # Try to get the scheduled task by name
            $task = Get-ScheduledTask | Where-Object { $_.TaskName -eq "$taskName" }

            # Check if the task was found
            if ($task) {
                Write-Output "Scheduled task '$taskName' found. Status: Compliant"
            } else {
                Write-Output "Scheduled task '$taskName' not found. Status: Non-Compliant"
            }
        }

        if ($appName -like "*Secura*" -and $appVersion -eq "4.00") {
            Write-Output "Secura application found with version 4.00. Status: Compliant"
        }
    }
}

Write-Output "Registry scan completed."
