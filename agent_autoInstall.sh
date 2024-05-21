#!/bin/bash

IP="$1"
comm_string="$2"

#usage 
if [ $# -ne 2 ]; then
  echo "Usage: $0 <monitor's IP> <community string>"
  echo "   <monitor's IP>: The IPv4 adrress or domain of the monitor host "
  echo "   <community string>: The community string to let monitor host connect to"
  exit 1
fi

# Check sudo privilige
if ! sudo -n true >/dev/null 2>&1; then
  echo "Error: This script requires sudo privileges."
  exit 1
fi

# Identify package manager
if [ -x "$(command -v yum)" ]; then
  package_manager="yum"
elif [ -x "$(command -v apt-get)" ]; then
  package_manager="apt-get"
elif [ -x "$(command -v dnf)" ]; then
  package_manager="dnf"
else
  echo "Error: Unsupported package manager. This script supports yum, apt-get, or dnf."
  exit 1
fi

#update and install snmp agent 
case $package_manager in
  yum)
    sudo yum update -y
    sudo yum install net-snmp -y
    ;;
  apt-get)
    sudo apt-get update -y
    sudo apt-get install snmpd -y
    ;;
  dnf)
    sudo dnf update -y
    sudo dnf install net-snmp -y
    ;;
esac

# Check for successful installation
if [ $? -eq 0 ]; then
  echo "SNMP agent installed successfully."
else
  echo "Error: Failed to install SNMP agent."
fi


#Back up and configure the monitor IP, community string

#Check config file
config_file="/etc/snmp/snmpd.conf"
if [ ! -f "$config_file" ]; then
  echo "Error: SNMP configuration file not found."
  exit 1
fi

#Backup the config
cp "$config_file" "$config_file.bak"
echo "Backed up config file to : $config_file.bak"

#Add the config
echo "" >> "$config_file"
echo "agentAddress udp:161" >>"$config_file"
echo "rocommunity $comm_string $IP" >> "$config_file"

#open port 161 on firewall
if command -v sudo ufw status &> /dev/null; then
  sudo ufw allow 161
elif command -v iptables &> /dev/null; then
  sudo iptables -A INPUT -p udp --dport 161 -j ACCEPT
elif systemctl is-active firewalld; then
  sudo firewall-cmd --permanent --zone=public --add-port=161/udp
  sudo firewall-cmd --reload
else
  echo "No firewall was found or can't detect the firewall."

fi

#restart snmp service to apply the change
sudo service snmpd restart

