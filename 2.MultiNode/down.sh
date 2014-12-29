#!/bin/bash

# Vagrant Cassandra Project
# Brian Cantoni
#
# Clean shutdown of each node (rather than just vagrant halting everything)

for i in {0..3}
do
  echo Shutting down node$i
  vagrant ssh node$i -c 'sudo shutdown -h now'
done

echo Done
