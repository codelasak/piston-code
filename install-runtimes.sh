#!/bin/bash

# Script to install common Piston runtimes after the container is running
# Usage: docker exec -it <container_name> /install-runtimes.sh

set -e

echo "Installing common language runtimes..."

# Wait for Piston API to be ready
echo "Waiting for Piston API to start..."
while ! curl -f http://localhost:2000/api/v2/runtimes 2>/dev/null; do
    sleep 2
    echo "Still waiting for Piston API..."
done

echo "Piston API is ready!"

# Clone Piston repo for CLI access
cd /tmp
git clone https://github.com/engineer-man/piston.git
cd piston/cli
npm install

echo "Installing Python runtime..."
node index.js ppman install python

echo "Installing GCC (C/C++) runtime..."
node index.js ppman install gcc

echo "Installing Node.js runtime..."
node index.js ppman install node

echo "Installing Java runtime..."
node index.js ppman install java || echo "Java installation failed, continuing..."

echo "Installing Go runtime..."
node index.js ppman install go || echo "Go installation failed, continuing..."

# Clean up
cd /
rm -rf /tmp/piston

echo "Runtime installation completed!"
echo "Available runtimes:"
curl -s http://localhost:2000/api/v2/runtimes | jq -r '.[].language' 2>/dev/null || echo "Install jq to see formatted runtime list"