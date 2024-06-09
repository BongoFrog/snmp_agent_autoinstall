import csv
import sys

def create_inventory(csv_file, inventory_file):
    with open(csv_file, 'r') as file:
        reader = csv.reader(file)
        hosts = []
        for row in reader:
            if len(row) != 3:
                print("Invalid entry:", row)
                continue
            ip, username, password = row
            host_entry = f"{ip} ansible_ssh_user={username} ansible_ssh_pass={password}"
            hosts.append(host_entry)

    with open(inventory_file, 'w') as file:
        file.write("[snmp_agent]\n")
        for host in hosts:
            file.write(host + "\n")

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] == "-h" or sys.argv[1] == "--help":
        print("Usage: python script_name.py hosts.csv")
        print("CSV file format:")
        print("IP,Username,Password")
        sys.exit(1)
        
    csv_file = sys.argv[1]
    inventory_file = "inventory.ini"
    create_inventory(csv_file, inventory_file)
    print(f"Inventory file '{inventory_file}' created successfully.")
