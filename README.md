# SNMP Agent Auto-Install Script

This script automates the installation and configuration of the SNMP agent on Linux systems. It checks for administrative privileges, identifies the system's package manager, installs the SNMP agent, configures it, and adjusts firewall settings to allow SNMP traffic.

## Prerequisites

- The script must be run as root or with sudo privileges.
- The target system should have one of the following package managers installed: `yum`, `apt-get`, or `dnf`.

## Usage

To run the script, use the following command:

sudo ./agent_autoInstall.sh <monitor's IP> <community string>


- `<monitor's IP>`: The IPv4 address or domain of the monitor host.
- `<community string>`: The community string to let the monitor host connect to.

## What the Script Does

1. **Checks for sudo privileges**: Ensures the script is run with root privileges.
2. **Parameter validation**: Checks if the correct number of arguments are provided.
3. **Identifies the package manager**: Detects and selects the package manager (`yum`, `apt-get`, or `dnf`).
4. **Updates package lists**: Updates the system's package list to ensure the latest versions of packages are available.
5. **Installs SNMP agent**: Installs the SNMP daemon using the identified package manager.
6. **Checks installation success**: Verifies that the SNMP agent was successfully installed.
7. **Backs up SNMP configuration**: Creates a backup of the existing SNMP configuration file.
8. **Configures SNMP**: Adds the specified monitor IP and community string to the SNMP configuration.
9. **Configures firewall**: Opens UDP port 161 on the firewall to allow SNMP traffic.
10. **Restarts SNMP service**: Restarts the SNMP service to apply the new configuration.

## Firewall Configuration

The script attempts to configure the firewall using `ufw`, `iptables`, or `firewalld`, depending on what is available on the system.

## Notes

- Ensure that the IP address and community string are correctly specified when running the script.
- The script currently supports systems with `yum`, `apt-get`, or `dnf` package managers. If your system uses a different package manager, the script will need to be modified accordingly.