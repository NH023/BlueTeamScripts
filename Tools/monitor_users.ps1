#Requires -runAsAdministrator

$sleeping_time = 300 # 5 Minutes
$log_file = (Get-Content "./config/config.json" | ConvertFrom-Json).LoggingLocations.UserUpdates
$latest_snapshot = ($log_file  + "latest.json")

# Create the folder if it doesn't exist
if(-Not (Test-Path -Path $log_file))
{
    Create-Item -Type "Directory" -Path $log_file
}

function Create-UserSnapshot
{
    # Create the Latest Snapshot Json File
    New-Item -Force -Type "File" -Path $latest_snapshot -Value "{}"

    $users = Get-LocalUser

    ForEach($user in $users)
    {
        # Get the User Data
        $name = $user.Name
        $enabled = $user.Enabled
        $description = $user.Description

        # Create an Object of basic Data
        $obj = [PSCustomObject]@{}
        $obj | Add-Member -Type "NoteProperty" -Name "enabled" -Value $enabled
        $obj | Add-Member -Type "NoteProperty" -Name "description" -Value $description

        # Add to the json file
        $json = Get-Content $latest_snapshot | ConvertFrom-Json
        $json | Add-Member -Type "NoteProperty" -Name $name -Value $obj
        $json | ConvertTo-Json | Set-Content $latest_snapshot
    }
}

function Check-Users
{

    # If no previous check was done, create a snapshot
    if(-Not (Test-Path $latest_snapshot))
    {
        Create-UserSnapshot
        Write-Output "Created Initial Snapshot of Users"
    } else {
        # Compare New to Old User
        $users = Get-LocalUser
        
    }


}

while($true)
{
    Check-Users
    Write-Output "Checked Users"
    Start-Sleep -Seconds $sleeping_time
}