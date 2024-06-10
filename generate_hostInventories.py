import csv
import sys

def create_inventory(csv_file, inventory_file):
    try:
        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            hosts = []
            for row in reader:
                if len(row) != 3:
                    print("Invalid entry:", row)
                    continue
                ip, username, password = row
                host_entry = (
                    f"{ip} ansible_user={username} ansible_ssh_pass={password} "
                    f"ansible_become=true ansible_become_method=sudo ansible_become_pass={password}"
                )
                hosts.append(host_entry)

        with open(inventory_file, 'w') as file:
            file.write("[snmp_agent]\n")
            for host in hosts:
                file.write(host + "\n")
        
        print(f"Inventory file '{inventory_file}' created successfully.")
    except FileNotFoundError:
        print(f"Error: The file '{csv_file}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] in ("-h", "--help"):
        print("Usage: python script_name.py hosts.csv")
        print("CSV file format:")
        print("IP,Username,Password")
        sys.exit(1)
        
    csv_file = sys.argv[1]
    inventory_file = "inventory.ini"
    create_inventory(csv_file, inventory_file)
