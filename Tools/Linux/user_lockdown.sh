#!/bin/bash

# The following script will query for a list of users, check it against the safe / viable users, and remove any extra
# It will also change the default passwords for all the existing, valid users


# valid_users_raw=$(cat $user_path)
# readarray -t valid_users <<< "${valid_users_raw}"

# echo ${valid_users[1]}

# readarray -t valid_users <<< "${cat pwd}"


# Get an array of the Users on the System
user_string=$(cut -d: -f1 /etc/passwd)
readarray -t users <<< "$user_string"

# Get an array of the allowed users from ./config/users directory
valid_users_raw=$(grep -rh -E -e '' ./config/users/)
readarray -t valid_users <<< "$valid_users_raw"

# Users that should get a password change
changed_users_raw=$(grep -rh -E -e '' ./config/users/competition)
readarray -t changed_users <<< "$changed_users_raw"

# Remove Carraige Return and New Line (Windows End of Line)
for ((i=0; i < ${#valid_users[@]}; i++)); do
    valid_users[i]=$(printf '%s' "${valid_users[i]}" | tr -d '\r \n')
done

# Remove Carraige Return and New Line (Windows End of Line)
for ((i=0; i < ${#changed_users[@]}; i++)); do
    changed_users[i]=$(printf '%s' "${changed_users[i]}" | tr -d '\r \n')
done

# See if each user on the system is in the valid_users array
# If they are in the array, leave, and set aside
# If they are not in the array, force delete the user

function goodUser()
{
    # Change the password of each user
    local pass=$(echo $1 | openssl dgst -sha256 -hmac $2 -binary | base64 | tr -d '/+=' | cut -c1-"15")
    unset master_key
    sudo chpasswd <<< "$1:$pass"
    echo "Changed Password: $1"
}

function badUser()
{
    # Force Delete the User
    sudo userdel -rf $1 2> /dev/null
    echo "Removed User: $1"
}

# Generate a Secure Password
exec 3<>/dev/tty
read -s -p "Master Key: " MASTER_KEY <&3
echo >&3
exec 3<&-

# Check if a system user is a valid user
for user in ${users[@]}; do
    valid=0
    for valid_user in ${valid_users[@]}; do
        if [ $user == $valid_user ]; then
            valid=1
            break
        fi
    done
    if [ $valid -eq 1 ]; then
        # Check if the valid user should have its password changed
        for change_user in ${changed_users[@]}; do
            if [ $user == $change_user ]; then
                goodUser $user $MASTER_KEY
                break
            fi
        done
    else
        # Bad User
        badUser $user
    fi
done
unset MASTER_KEY
