# SNMP Agent Auto-Install Script

This script automates the installation and configuration of the SNMP agent on Linux systems. It is designed to be run with root privileges and supports multiple package managers.

## Prerequisites

- The script must be run as root or with sudo privileges.
- The target system should have one of the following package managers installed: `yum`, `apt-get`, `dnf`, or `zypper`.

## Usage

To run the script, use the following command:

```bash
sudo ./agent_autoInstall.sh <monitor's IP> <community string>
```

- `<monitor's IP>`: The IPv4 address or domain of the monitor host.
- `<community string>`: The community string to let the monitor host connect to.

## Features

- Checks for sudo privileges.
- Identifies the package manager available on the system.
- Updates the package list.
- Installs the SNMP agent.
- Backs up the existing SNMP configuration file.
- Configures SNMP with the provided community string and monitor IP.
- Opens port 161 on the firewall using `ufw`, `iptables`, or `firewalld` depending on what is available.
- Restarts the SNMP service to apply changes.

## Error Handling

- The script will exit if it does not have sudo privileges.
- It will also exit if the required parameters are not provided or if the SNMP configuration file is not found.
- If the SNMP agent fails to install, the script will exit.

## Supported Systems

This script has been tested on systems using `yum`, `apt-get`, `dnf`, and `zypper` as package managers. It should work on most Linux distributions that use these package managers.

## Note

This script makes significant changes to system configuration, including firewall settings. Please review the script and understand its impact before running it on a production system.
