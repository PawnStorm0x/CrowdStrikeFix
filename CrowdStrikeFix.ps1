# CrowdStrikeFix.ps1
# This script deletes the problematic CrowdStrike driver file causing BSODs and reverts Safe Mode

# Function to set the system to boot into Safe Mode
function Set-SafeMode {
    Write-Output "Setting the system to boot into Safe Mode..."
    bcdedit /set {current} safeboot minimal
    Write-Output "System set to boot into Safe Mode on next reboot."
}

# Function to set the system to boot into Normal Mode
function Set-NormalBoot {
    Write-Output "Setting the system to boot into Normal Mode..."
    bcdedit /deletevalue {current} safeboot
    Write-Output "System set to boot into Normal Mode on next reboot."
}

# Function to delete the problematic CrowdStrike driver file
function Delete-ProblematicDriver {
    param ([string]$filePath)

    $files = Get-ChildItem -Path $filePath -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        try {
            Remove-Item -Path $file.FullName -Force
            Write-Output "Deleted: $($file.FullName)"
        } catch {
            Write-Output "Failed to delete: $($file.FullName)"
        }
    }
}

# Main script logic
Write-Output "Starting the script to delete the problematic CrowdStrike driver..."
Set-SafeMode
Restart-Computer -Force

# After reboot into Safe Mode
Write-Output "System rebooted into Safe Mode."
$filePath = "C:\Windows\System32\drivers\C-00000291*.sys"
Delete-ProblematicDriver -filePath $filePath
Set-NormalBoot
Restart-Computer -Force
