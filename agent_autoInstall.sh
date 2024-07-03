#!/bin/bash

# Check sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script requires sudo privileges."
  exit 1
fi

IP="$1"
comm_string="$2"

# Usage message
if [ $# -ne 2 ]; then
  echo "Usage: $0 <monitor's IP> <community string>"
  echo "   <monitor's IP>: The IPv4 address or domain of the monitor host."
  echo "   <community string>: The community string to let monitor host connect to."
  exit 1
fi

# Identify package manager
if [ -x "$(command -v yum)" ]; then
  package_manager="yum"
elif [ -x "$(command -v apt-get)" ]; then
  package_manager="apt-get"
elif [ -x "$(command -v dnf)" ]; then
  package_manager="dnf"
elif [ -x "$(command -v zypper)" ]; then
  package_manager="zypper"
else
  echo "Error: Unsupported package manager. This script supports yum, apt-get, or dnf."
  exit 1
fi

# Update package lists
case $package_manager in
  yum)
    sudo yum update -y
    ;;
  apt-get)
    sudo apt-get update -y
    ;;
  dnf)
    sudo dnf makecache
    ;;
  zypper)
    sudo zypper refresh
    ;;
esac

# Install SNMP agent
case $package_manager in
  yum)
    sudo yum install -y net-snmp 
    ;;
  apt-get)
    sudo apt-get install -y snmpd 
    ;;
  dnf)
    sudo dnf install -y net-snmp 
    ;;
  zypper)
    sudo zypper install -y net-snmp 
    ;;
esac

# Check for successful installation
if [ $? -ne 0 ]; then
  echo "Error: Failed to install SNMP agent."
  exit 1
fi

# Backup and configure the monitor IP, community string
config_file="/etc/snmp/snmpd.conf"

# Check config file
if [ ! -f "$config_file" ]; then
  echo "Error: SNMP configuration file not found."
  exit 1
fi

# Backup the config
sudo cp "$config_file" "$config_file.bak"
echo "Backed up config file to: $config_file.bak"

# Add the config
sudo tee -a "$config_file" > /dev/null <<EOT

# Added by SNMP setup script
agentAddress udp:161
rocommunity $comm_string $IP
EOT

# Open port 161 on firewall
if command -v ufw &> /dev/null; then
  sudo ufw allow 161
fi
  echo "Allow port 161 on UFW"
if command -v iptables &> /dev/null; then
  sudo iptables -A INPUT -p udp --dport 161 -j ACCEPT
  echo "Allow port 161 on iptables."
fi
if systemctl is-active firewalld | grep -q "active" ; then
  sudo firewall-cmd --add-port=161/udp --permanent 
  sudo firewall-cmd --reload
  echo "Allow port 161 on firewalld."
fi

# Restart SNMP service
sudo systemctl enable snmpd
sudo systemctl restart snmpd
