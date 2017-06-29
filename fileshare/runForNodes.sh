#!/bin/bash

# Install jq used for the next command
sudo apt-get install jq -y

# Get the IP address of each node using the mesos API and store it inside a file called nodes
# To target specific slave nodes only, add a query to filter, e.g. select(.resources.gpus == 1)
curl http://leader.mesos:5050/slaves | jq '.slaves[].hostname' | sed 's/\"//g' | sed '/172/d' > slaves

# From the previous file created, run our script to mount our share on each node
cat slaves | while read line
do
  ssh `whoami`@$line -t -o StrictHostKeyChecking=no 'sudo bash -s'< cifsMount.sh
  done