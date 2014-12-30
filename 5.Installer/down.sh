#!/bin/bash

# Vagrant Cassandra Project
# Brian Cantoni
#
# Clean shutdown of each node (rather than just vagrant halting everything)

for i in $(seq 1 ${VAGRANT_DSE_NODES=1})
do
  j=$((i-1))
  echo Shutting down dse1$j
  vagrant ssh dse1$j -c 'sudo service dse stop; sleep 5; sudo shutdown -h now'
done

echo Done
