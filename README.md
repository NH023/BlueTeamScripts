# Blue Team Scripts

## Important Scripts
> `repo_download.ps1` > Download Scripts to a Desired Folder \
> Requirements: git, administrator

> `repo_dowload.sh` > Same as above for Linux \
> Requirements: git

## Directories
> `./Tools` \
> Create any necessary scripts under this directory in the correct folder. \
> `./Tools/Windows` : .ps1 Powershell Scripts \
> `./Tools/Linux` : .sh Bash Scripts

> `./Logging/` \
> Insert any necessary logs for the script under a separate folder. \
> Example: `./Tools/Windows/monitor_users.ps1` creates logs in `./Logging/UserUpdates`

> `./Tools/*/config` \
> Each tools directory has its own config folder (repo_download only downloads the folder for the correct OS). \
> If the script needs script-specific configurations, put it in its own config file. \
> Example: The `test.sh` script can use `./Tools/Linux/config/test_config.json`. \
> If you have a configuration that is common to multiple scripts, you can use the general `config.json` file.