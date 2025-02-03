# Terminate the datacard.dccm.devicepluginservice.exe process
try {
    taskkill /IM datacard.dccm.devicepluginservice.exe /T /F
    Write-Output "Successfully terminated datacard.dccm.devicepluginservice.exe."
} catch {
    Write-Warning "Failed to terminate datacard.dccm.devicepluginservice.exe. Error: $_"
}

# Terminate the datacard.dccm.capturemanager.exe process
try {
    taskkill /IM datacard.dccm.capturemanager.exe /T /F
    Write-Output "Successfully terminated datacard.dccm.capturemanager.exe."
} catch {
    Write-Warning "Failed to terminate datacard.dccm.capturemanager.exe. Error: $_"
}

# Stop the DatacardCaptureManager service
try {
    net stop DatacardCaptureManager
    Write-Output "Successfully stopped DatacardCaptureManager service."
} catch {
    Write-Warning "Failed to stop DatacardCaptureManager service. Error: $_"
}
