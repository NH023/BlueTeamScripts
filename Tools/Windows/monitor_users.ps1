#Requires -runAsAdministrator

$sleeping_time = 300 # 5 Minutes
$log_folder = (Get-Content "./config/config.json" | ConvertFrom-Json).LoggingLocations.UserUpdates
$latest_snapshot = ($log_folder  + "latest.json")

# Create the folder if it doesn't exist
if(-Not (Test-Path -Path $log_folder))
{
    Create-Item -Type "Directory" -Path $log_folder
}

function Create-UserSnapshot
{
    # Create the Latest Snapshot Json File
    New-Item -Force -Type "File" -Path $latest_snapshot -Value "{}" | Out-Null
    Write-Host $latest_snapshot

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
        $users_new = Get-LocalUser

        $users_old = Get-Content $latest_snapshot | ConvertFrom-Json
        
        $date = Get-Date -Format "HH.MM.ss mm-dd-yy"
        $current_log_file_path = ($log_folder + "$date.log")
        New-Item -Force -Type File -Path $current_log_file_path | Out-Null

        # Check for Newly Created Users
        ForEach($user_new in $users_new)
        {
            $found = $false
            ForEach($user_old in $users_old.psobject.properties.name)
            {
                $name = $user_new.Name
                if($user_new.Name -eq $user_old)
                {
                    $found = $true
                    break
                }
            }
            if(-Not $found)
            {
                $name = $user_new.Name
                $description = $user_new.Description
                "New User Created`nName: $name`nDescription: $description`n" >> $current_log_file_path
            }
        }

        # Check for Deleted Users
        ForEach($user_old in $users_old.psobject.properties.name)
        {
            $found = $false
            ForEach($user_new in $users_new)
            {
                $name = $user_new.Name
                if($user_new.Name -eq $user_old)
                {
                    $found = $true
                    break
                }
            }
            if(-Not $found)
            {
                $name = $user_old
                Write-Host $user_old
                $description = $users_old.$user_old.description
                "User Deleted`nName: $name`nDescription: $description`n" >> $current_log_file_path
            }
        }



        # Refresh the latest.json
        Create-UserSnapshot
        
    }


}

while($true)
{
    Check-Users
    Write-Output "Checked Users"
    Start-Sleep -Seconds $sleeping_time
}