# Check and terminate the datacard.dccm.devicepluginservice.exe process
if (Get-Process -Name "datacard.dccm.devicepluginservice" -ErrorAction SilentlyContinue) {
    try {
        taskkill /IM datacard.dccm.devicepluginservice.exe /T /F
        Write-Output "Successfully terminated datacard.dccm.devicepluginservice.exe."
    } catch {
        Write-Warning "Failed to terminate datacard.dccm.devicepluginservice.exe. Error: $_"
    }
} else {
    Write-Warning "datacard.dccm.devicepluginservice.exe is not running."
}

# Check and terminate the datacard.dccm.capturemanager.exe process
if (Get-Process -Name "datacard.dccm.capturemanager" -ErrorAction SilentlyContinue) {
    try {
        taskkill /IM datacard.dccm.capturemanager.exe /T /F
        Write-Output "Successfully terminated datacard.dccm.capturemanager.exe."
    } catch {
        Write-Warning "Failed to terminate datacard.dccm.capturemanager.exe. Error: $_"
    }
} else {
    Write-Warning "datacard.dccm.capturemanager.exe is not running."
}

# Check and stop the DatacardCaptureManager service
$service = Get-Service -Name "DatacardCaptureManager" -ErrorAction SilentlyContinue
if ($service.Status -eq 'Running') {
    try {
        net stop DatacardCaptureManager
        Write-Output "Successfully stopped DatacardCaptureManager service."
    } catch {
        Write-Warning "Failed to stop DatacardCaptureManager service. Error: $_"
    }
} else {
    Write-Warning "DatacardCaptureManager service is not running."
}
