# One-Liner to Download this Shell Script
# wget https://raw.githubusercontent.com/NH023/BlueTeamScripts/refs/heads/main/repo_download.ps1 -O repo_download.ps1

# If windows prevents scripts from running, run the following command
# Set-ExecutionPolicy Bypass

$archive_link = "https://github.com/NH023/BlueTeamScripts/archive/refs/heads/main.zip"
$extraction_path = "C:/Program Files/Steam/"
$download_path = "C:/Program Files/Steam/CSGO.zip"

#Requires -runAsAdministrator

try
{

    # Create the Directory if not already made
    if(-Not (Test-Path $extraction_path))
    {
        New-Item -Type "Directory" -Path $extraction_path 
    }

    # Download the zip file with tools
    Invoke-WebRequest -Uri $archive_link -OutFile $download_path
    
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
