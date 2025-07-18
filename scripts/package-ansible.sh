#!/bin/bash
set -e

# Script to package Ansible playbooks for cloud-init deployment
# This script creates a zip file containing all Ansible playbooks and templates

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(dirname "$SCRIPT_DIR")"
ANSIBLE_DIR="$MODULE_DIR/ansible"
OUTPUT_DIR="$MODULE_DIR/packaged"

echo "Packaging Ansible playbooks..."

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Create temporary directory for packaging
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="$TEMP_DIR/humhub-ansible"

# Copy Ansible files to package directory
mkdir -p "$PACKAGE_DIR"
cp -r "$ANSIBLE_DIR"/* "$PACKAGE_DIR/"

# Create the zip file
cd "$TEMP_DIR"
zip -r "$OUTPUT_DIR/humhub-ansible.zip" humhub-ansible/

# Generate base64 encoded content for cloud-init
base64 -w 0 "$OUTPUT_DIR/humhub-ansible.zip" > "$OUTPUT_DIR/ansible-base64.txt"

# Clean up
rm -rf "$TEMP_DIR"

echo "Ansible playbooks packaged successfully:"
echo "  - Zip file: $OUTPUT_DIR/humhub-ansible.zip"
echo "  - Base64 file: $OUTPUT_DIR/ansible-base64.txt"
echo ""
echo "To use in Terraform, reference the base64 content in your cloud-init templates."