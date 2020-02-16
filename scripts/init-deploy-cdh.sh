#!/bin/bash
basepath=`dirname $0`
# inventory=$basepath/../inventory/mango
playbook=$basepath/../playbooks/cloudera.yml
ansible-playbook $playbook