# This will download the windows sys internals suite
# https://download.sysinternals.com/files/SysinternalsSuite.zip

$sys_internals_link = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$extraction_path = "C:/Program Files/Testing/Tooly"
$download_path = "C:/Program Files/Testing/Internal.zip"

#requires -runAsAdministrator

try
{
    # Create the Directory if not already made
    if(-Not (Test-Path $extraction_path))
    {
        New-Item -Type "Directory" -Path $extraction_path 
    }

    # Download the zip file with tools
    Invoke-WebRequest -Uri $sys_internals_link -OutFile $download_path
    
    # Unzip the File
    Expand-Archive -Force -Path $download_path -DestinationPath $extraction_path

    # Delete the zip file
    Remove-Item -Force -Path $download_path

    # Output notification
    Write-Output "Finished Downloading Tools!"
} catch 
{
    Write-Host "An error has occured: $_.Exception.Message"
}
