#!/bin/bash

# Redirect all output (stdout and stderr) to /opt/ansible-playbook.log
exec > /opt/ansible-playbook.log 2>&1

# Install Ansible
dnf install -y ansible

# Clone the repository to /tmp
cd /tmp
git clone https://github.com/wavedevops/expense-ansible

# Navigate to the cloned repository
cd expense-ansible

# Run the Ansible playbook for the frontend component
ansible-playbook main.yml -e component=frontend


cd /tmp/expense-ansible && ansible-playbook main.yml -e component=frontend