#!/bin/bash

# Function to check if an IP is valid
is_valid_ip() {
  local ip=$1
  # Check if IP matches the format of a valid IPv4 address
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    # Split the IP into its octets and ensure each one is <= 255
    for octet in ${ip//./ }; do
      if ((octet < 0 || octet > 255)); then
        return 1
      fi
    done
    return 0
  fi
  return 1
}

# Read /etc/hosts and check each IP
while read -r line; do
  # Ignore comments and empty lines
  [[ $line =~ ^#.*$ || -z $line ]] && continue

  # Extract the first field (IP) from the line
  ip=$(echo "$line" | awk '{print $1}')

  # Check if it is a valid IP
  if is_valid_ip "$ip"; then
    echo "Valid IP: $ip"
  else
    echo "Invalid IP: $ip"
  fi
done </etc/hosts
