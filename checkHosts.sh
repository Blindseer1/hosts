#!/bin/bash

# Function to check if a hostname is associated with an IP address using a specific DNS server
check_ip_association() {
  local hostname=$1
  local ip=$2
  local dns_server=$3

  # Use dig to resolve the hostname with the specified DNS server
  resolved_ip=$(dig +short "$hostname" @"$dns_server")

  # Check if the resolved IP matches the provided IP
  if [[ "$resolved_ip" == "$ip" ]]; then
    echo "The IP address $ip is correctly associated with the hostname $hostname on DNS server $dns_server."
  else
    echo "The IP address $ip does NOT match the hostname $hostname on DNS server $dns_server."
  fi
}

# Example usage with parameters
# check_ip_association "example.com" "93.184.216.34" "8.8.8.8"

# For usage with multiple entries in /etc/hosts
while IFS= read -r line; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  # Extract IP and hostname from each line in /etc/hosts
  ip=$(echo "$line" | awk '{print $1}')
  hostname=$(echo "$line" | awk '{print $2}')

  # Specify the DNS server (example: Google's DNS server)
  dns_server="8.8.8.8"

  # Check association
  check_ip_association "$hostname" "$ip" "$dns_server"
done <"/etc/hosts"
