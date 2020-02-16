#!/bin/bash
basepath=`dirname $0`
inventory=$basepath/../hosts
playbookpath=$basepath/../playbooks
ansible-playbook -i $inventory $playbookpath/remove-cdh.yml
ansible-playbook -i $inventory $playbookpath/remove-database.yml