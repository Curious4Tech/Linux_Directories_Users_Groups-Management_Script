#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to install figlet
install_figlet() {
    if [ -x "$(command -v apt)" ]; then
        echo "Installing figlet using apt..."
        sudo apt update
        sudo apt install -y figlet
    elif [ -x "$(command -v yum)" ]; then
        echo "Installing figlet using yum..."
        sudo yum install -y figlet
    else
        echo "Package manager not found. Please install figlet manually."
        exit 1
    fi
}

# Check if figlet is installed
if ! command -v figlet &> /dev/null; then
    echo "figlet is not installed. Installing now..."
    install_figlet
fi

# Print the banner
figlet -f small " Welcome to the Setup" 
echo -e "${GREEN}======================================================${NC}"
echo -e "${RED}  Directories, Users, Groups & Groups Ownership Setup ${NC}"
echo -e "${GREEN}=======================================================${NC}"

# Global array to store directory names
declare -a dir_names

# Function to create directories in the home directory
create_directories() {
    local dir_count
    read -p "Enter the number of directories to create: " dir_count

    for ((i=1; i<=dir_count; i++)); do
        while true; do
            read -p "Enter name for directory $i (it will be created in /home/): " dir_name
            if [[ -d "/home/$dir_name" ]]; then
                echo -e  "${RED} Directory /home/$dir_name already exists. Please choose another name.${NC}"
            else
                sudo mkdir -p "/home/$dir_name"
                # Set GID and sticky bits on the directory
                sudo chmod g+s "/home/$dir_name"  # Set GID bit
                sudo chmod o+t "/home/$dir_name"  # Set sticky bit
                echo -e "${GREEN} Created directory: /home/$dir_name with GID and sticky bits set.${NC}"
                dir_names+=("$dir_name")
                break
            fi
        done
    done
}

# Function to create users
create_users() {
    local user_count
    read -p "Enter the number of users to create: " user_count

    for ((i=1; i<=user_count; i++)); do
        while true; do
            read -p "Enter username for user $i: " username
            if id "$username" &>/dev/null; then
                echo -e "${RED} User $username already exists. Please choose another username.${NC}"
            else
                sudo useradd "$username"
                echo -e "${GREEN} Created user: $username.${NC}"
                break
            fi
        done
    done
}

# Function to create groups
create_groups() {
    local group_count
    read -p "Enter the number of groups to create: " group_count

    for ((i=1; i<=group_count; i++)); do
        while true; do
            read -p "Enter name for group $i: " group_name
            if getent group "$group_name" > /dev/null; then
                echo -e "${RED} Group $group_name already exists. Please choose another group name.${NC}"
            else
                sudo groupadd "$group_name"
                echo -e "${GREEN} Created group: $group_name.${NC}"
                break
            fi
        done
    done
}

# Function to add users to specified groups
add_users_to_groups() {
    local pair_count
    read -p "Enter the number of user-group pairs to add: " pair_count

    for ((i=1; i<=pair_count; i++)); do
        while true; do
            read -p "Enter username for user $i: " username
            read -p "Enter the group to add user $username to: " group
            if ! id "$username" &>/dev/null; then
                echo -e "${RED} User $username does not exist. Please enter a valid username.${NC}"
            elif ! getent group "$group" > /dev/null; then
                echo -e "${RED} Group $group does not exist. Please enter a valid group name.${NC}"
            else
                sudo usermod -aG "$group" "$username"
                echo -e "${GREEN} Added user: $username to group: $group.${NC}"
                break
            fi
        done
    done
}

# Function to configure directory ownership
configure_directory_ownership() {
    for dir_name in "${dir_names[@]}"; do
        while true; do
            read -p "Enter username for ownership of directory $dir_name: " owner_user
            read -p "Enter group name for ownership of directory $dir_name: " owner_group

            if ! id "$owner_user" &>/dev/null; then
                echo -e "${RED}User $owner_user does not exist. Please enter a valid username.${NC}"
            elif ! getent group "$owner_group" > /dev/null; then
                echo -e "${RED} Group $owner_group does not exist. Please enter a valid group name.${NC}"
            else
                # Change ownership
                sudo chown "$owner_user:$owner_group" "/home/$dir_name"
                echo -e "${GREEN} Configured directory: /home/$dir_name. Owned by $owner_user:$owner_group.${NC}"
                break
            fi
        done
    done
}

# Main script execution
echo -e  "${GREEN} Directories, Users, Groups and Groups Ownership Creation Script.${NC}"
create_directories
create_users
create_groups
add_users_to_groups
configure_directory_ownership
echo " "
echo " "
echo -e "${GREEN} Verify that all users are successifully created : ${NC}" 
sudo cat /etc/shadow
echo " "
echo " "
echo -e "${GREEN} Verify that all groups are successifully created :${NC}" 
sudo cat /etc/group
echo " "
echo " "
echo -e "${GREEN} Verify that all directories are created successifully, GID and Sticky bit are set and directories ownership are correct :${NC}" 
sudo ls -ld /home/*
echo " "
echo " "
echo -e "${GREEN} All specified directories, users, and groups have been created and configured.${NC}"
