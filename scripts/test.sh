#!/bin/bash
basepath=`dirname $0`
inventory=$basepath/../hosts
playbook=$basepath/../playbooks/cloudera.yml
# include cm_agents and cm_server because hosts name and ip may change
ansible-playbook -i $inventory $playbook --tags="cm_server"