# Directory and User Management Script

This Bash script automates the process of creating and managing directories, users, groups, and their ownership on a Linux system. It provides an interactive interface for system administrators to easily set up and configure these elements.

## Features

- Create multiple directories in the /home/ directory
- Set GID and sticky bits on created directories
- Create multiple users
- Create multiple groups
- Add users to specified groups
- Configure directory ownership
- Verify created users, groups, and directories

## Prerequisites

- A Linux-based operating system
- Sudo privileges
- `figlet` package (the script will attempt to install it if not present)

## Installation

1. Clone this repository or download the script file.
2. Make the script executable:
   ```
   chmod +x setup_script.sh
   ```

## Usage

Run the script with sudo privileges:

```
sudo ./setup_script.sh
```

Follow the interactive prompts to:
1. Create directories
2. Create users
3. Create groups
4. Add users to groups
5. Configure directory ownership

The script will guide you through each step and provide feedback on the actions taken.

## Script Breakdown

### Initial Setup
- The script starts by defining color codes for output formatting.
- It checks for and installs the `figlet` package if not present.
- A welcome banner is displayed using `figlet`.

### Main Functions

1. `create_directories()`: 
   - Creates specified number of directories in /home/
   - Sets GID and sticky bits on each directory

2. `create_users()`: 
   - Creates specified number of user accounts

3. `create_groups()`: 
   - Creates specified number of groups

4. `add_users_to_groups()`: 
   - Adds specified users to specified groups

5. `configure_directory_ownership()`: 
   - Sets ownership of created directories to specified users and groups

### Verification

After executing all functions, the script verifies the creation of:
- Users (by displaying /etc/shadow)
- Groups (by displaying /etc/group)
- Directories (by listing /home/ with detailed attributes)

## Security Considerations

- This script requires sudo privileges and should be used carefully.
- It modifies system users, groups, and directories, which can have system-wide impacts.
- Ensure you have proper backups before running this script on a production system.

## Contributing

Contributions to improve the script are welcome. Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- The `figlet` package for creating ASCII text banners.

