#!/bin/bash
echo "-============ Executing Ansible Playbook ==============-"
chmod 600 id_rsa
ansible -i inventory all -m ping