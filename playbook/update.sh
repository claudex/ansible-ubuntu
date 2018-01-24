#!/bin/bash

# Launch the ansible playbook when necessary.
# Launch this file with cron (as the user 'ansible')

if [ ! $# -eq 3 ]
  then
    echo "Three arguments are required. Usage:"
    echo "./updated_deliveries.sh PLAYBOOK_PATH BO_ADDRESS ANSIBLE_PATH"
    exit 1
fi

PLAYBOOK_PATH=$1
BO_ADDRESS=$2
ANSIBLE_PATH=$3

cd $PLAYBOOK_PATH

ssh ansible@$BO_ADDRESS sudo -u www-data /usr/local/bin/new_monarc_clients.sh | ./add_inventory.py ../inventory/

ssh ansible@$BO_ADDRESS sudo -u www-data /usr/local/bin/del_monarc_clients.sh | ./del_inventory.py ../inventory/

$ANSIBLE_PATH -i ../inventory/ monarc.yaml --user ansible

./list_inventory.py ../inventory/ | xargs -n2  ./update_deliveries.sh $BO_ADDRESS
