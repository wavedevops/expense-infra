#!/bin/bash
# user data will get sudo access
dnf install ansible -y
cd /tmp
git clone https://github.com/wavedevops/expense-ansible.git
cd expense-ansible
ansible-playbook main.yml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yml -e component=frontend