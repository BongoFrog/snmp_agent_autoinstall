# SNMP Agent Management Suite

This suite of tools and scripts is designed to automate the installation, configuration, and inventory management of SNMP agents on Linux systems using Ansible and Python. Below is a comprehensive guide to each component of the suite.

## Components

### 1. SNMP Agent Auto-Install Script

The `agent_autoInstall.sh` script automates the installation and configuration of SNMP agents on Linux systems. Ensure you have root or sudo privileges before running this script.

#### Prerequisites

- Root or sudo privileges.
- The system must have one of the following package managers: `yum`, `apt-get`, `dnf`, or `zypper`.

#### Installation and Configuration

Execute the script with the following command:

```bash
sudo ./agent_autoInstall.sh <monitor's IP> <community string>
```

#### Parameters

- `<monitor's IP>`: The IPv4 address or domain of the monitoring host.
- `<community string>`: The community string for SNMP communication.

#### Features

- Automatic detection and utilization of the system's package manager.
- Installs and configures the SNMP agent.
- Manages firewall settings to allow SNMP traffic.

### 2. SNMP Host Inventory Generator

The Python script `generate_hostInventories.py` automates the creation of an inventory file for SNMP agents from a CSV file.

#### Requirements

- Python 3.x

#### Usage

Run the script by passing the CSV file as an argument:

```bash
python generate_hostInventories.py hosts.csv
```

#### Output

Generates an `inventory.ini` file formatted for use with Ansible.

### 3. SNMP Agent Installation Automation with Ansible

This component uses an Ansible playbook, `snmp_agent.yml`, to automate the deployment of the SNMP agent using the `agent_autoInstall.sh` script.

#### Requirements

- Ansible 2.9 or higher
- SSH access to the target hosts

#### Playbook Description

```yaml
---
- name: Execute bash script with arguments
  hosts: snmp_agent
  gather_facts: no
  become: yes
  tasks:
    - name: Execute snmp script with ansible
      shell: agent_autoInstall.sh "{{ arg1 }}" "{{ arg2 }}"
      vars:
        arg1: value1
        arg2: value2
```

#### Usage

Run the playbook using the following command:

```bash
ansible-playbook -i inventory.ini snmp_agent.yml --extra-vars "arg1=<monitor's IP> arg2=<community string>"

```

## Conclusion

This suite provides a comprehensive set of tools for managing SNMP agents across multiple Linux distributions and environments, ensuring efficient deployment and configuration through automation.
