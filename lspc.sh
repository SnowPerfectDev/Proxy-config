#!/bin/bash

config_file="/etc/proxychains4.conf"
if [ ! -f "$config_file" ]; then
    echo "The configuration file $config_file does not exist."
    exit 1
fi

set -e

cp "$config_file" "$config_file.bak"
echo "Backup of the configuration file created: $config_file.bak"

sed -i "s/strict_chain/#strict_chain/g" "$config_file"
echo "Strict chain disabled."

sed -i "s/# Proxy DNS requests - no leak for DNS data/Proxy DNS requests - no leak for DNS data/g" "$config_file"
echo "DNS leak prevention enabled."

sed -i "s/#dynamic_chain/dynamic_chain/g" "$config_file"
echo "Proxychains configured as dynamic."

echo "socks5  127.0.0.1 9050" >> "$config_file"
echo "Proxychains configured to operate on port 9050."

echo "Proxychains configuration completed successfully!"
