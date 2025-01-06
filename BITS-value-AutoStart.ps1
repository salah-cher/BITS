# Define the registry path and value name for BITS
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\BITS"
$valueName = "Start"

# Function to get and display the current Start value
function Get-StartValue {
    param (
        [string]$Path,
        [string]$Name
    )
    try {
        $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
        Write-Output "Current Start value for BITS: $($currentValue.$Name)"
    } catch {
        Write-Output "Failed to retrieve the current Start value for BITS."
    }
}

# Function to set the Start value to Automatic (2)
function Set-StartValue {
    param (
        [string]$Path,
        [string]$Name,
        [int]$Value
    )
    try {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -ErrorAction Stop
        Write-Output "Successfully set the Start value for BITS to $Value."
    } catch {
        Write-Output "Failed to set the Start value for BITS."
    }
}

# Get and display the current Start value
Get-StartValue -Path $regPath -Name $valueName

# Set the Start value to Automatic (2)
Set-StartValue -Path $regPath -Name $valueName -Value 2

# Get and display the new Start value
Get-StartValue -Path $regPath -Name $valueName
