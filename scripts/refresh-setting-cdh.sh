#!/bin/bash
basepath=`dirname $0`
# inventory=$basepath/../inventory/mango
playbook=$basepath/../playbooks/cloudera.yml
# include cm_agents and cm_server because hosts name and ip may change
ansible-playbook $playbook --tags="repo,os"