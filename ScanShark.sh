#!/bin/bash

##   LazyCat      : 	Automated Nmap tool (preferred for boxes)
##   Author       : 	Alx-J 
##   Version  	: 	1.0
##   Github   	: 	https://github.com/Alx-J/lazyc4t


# Banner
cat << 'EOF'
      |\      _,,,---,,_
ZZZzz /,`.-'`'    -.  ;-;;,_
     |,4-  ) )-,_. ,\ (  `'-'
    '---''(_/--'  `-'\_)  lazy c4t

EOF

# Get the IP address from the user
ip="$1"
if [ -z "$ip" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# Perform the nmap scan and save the output to a temporary file
temp_output=$(mktemp)
nmap -p- "$ip" --min-rate=5000 -oN "$temp_output"

# Check if the temporary output file exists
if [ ! -f "$temp_output" ]; then
    echo "Temporary output file does not exist."
    exit 1
fi

# Extract port numbers from the temporary output file
port_numbers=$(grep -oP '^\d+(?=/)' "$temp_output" | tr '\n' ',' | sed 's/,$//')

# Remove the temporary output file
rm "$temp_output"

# Check if port numbers were found
if [ -z "$port_numbers" ]; then
    echo "No open ports found."
    exit 1
fi

# Perform a detailed nmap scan on the extracted ports
nmap -p"$port_numbers" "$ip" -A -oN scan_results.txt

# Perform a UDP scan on the target
nmap -sU -sV -F -open "$ip" -oN udp_scan_results.txt

cat << 'EOF'

    |\__/,|   (`\
  _.|o o  |_   ) )
-(((---(((--------------------------------------------------
Detailed scan results were saved to scan_results.txt & udp_scan_results.txt
EOF
