#!/bin/bash
echo "-============ Executing Ansible Playbook ==============-"
ansible -i inventory all -m ping