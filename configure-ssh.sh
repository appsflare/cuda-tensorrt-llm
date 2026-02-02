#!/bin/bash

# configure-ssh.sh
# Standardized script to install and configure OpenSSH server with PubkeyAuthentication enabled.
# Optional: Install authorized keys for a user from sshid.io
# Usage: sudo ./configure-ssh.sh [-u sshid_username]

set -e

# Function to display usage
usage() {
    echo "Usage: sudo $0 [-u sshid_username]"
    exit 1
}

# Parse options
SSHID_USER=""
while getopts "u:" opt; do
    case "$opt" in
        u) SSHID_USER=$OPTARG ;;
        *) usage ;;
    esac
done

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (using sudo)."
  exit 1
fi

echo "--- Installing OpenSSH Server ---"
apt-get update
apt-get install -y openssh-server curl

echo "--- Configuring SSHD ---"
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup the original config
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"

# 1. Enable PubkeyAuthentication
if grep -q "^#PubkeyAuthentication" "$SSHD_CONFIG"; then
    sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
elif grep -q "^PubkeyAuthentication" "$SSHD_CONFIG"; then
    sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
else
    echo "PubkeyAuthentication yes" >> "$SSHD_CONFIG"
fi

# 2. Ensure reasonable security defaults
if grep -q "^#PermitEmptyPasswords" "$SSHD_CONFIG"; then
    sed -i 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSHD_CONFIG"
elif grep -q "^PermitEmptyPasswords" "$SSHD_CONFIG"; then
    sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSHD_CONFIG"
fi

# 3. Create run directory if missing
mkdir -p /var/run/sshd

# 4. Optional: Install authorized keys from sshid.io
if [ -n "$SSHID_USER" ]; then
    echo "--- Installing Authorized Keys for user: $SSHID_USER ---"
    # Note: When run via sudo, ~ refers to /root. 
    # This installs the keys for the root user.
    AUTH_DIR="/root/.ssh"
    AUTH_FILE="$AUTH_DIR/authorized_keys"
    
    mkdir -p "$AUTH_DIR"
    chmod 700 "$AUTH_DIR"
    
    echo "Fetching keys from https://sshid.io/$SSHID_USER..."
    curl -fs "https://sshid.io/$SSHID_USER" >> "$AUTH_FILE"
    
    chmod 600 "$AUTH_FILE"
    echo "Keys added to $AUTH_FILE"
fi

echo "--- Starting SSH Service ---"
service ssh start

echo "--- SUCCESS ---"
echo "OpenSSH server installed and configured with PubkeyAuthentication=yes."
echo "Backup created at: ${SSHD_CONFIG}.bak"
if [ -n "$SSHID_USER" ]; then
    echo "SSH ID keys installed for root."
fi
