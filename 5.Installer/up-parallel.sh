#!/bin/bash

# Vagrant Cassandra Project
# Brian Cantoni
#
# Provisioning several VMs at once can be pretty slow depending on the speed of
# the Ubuntu mirrors at the time. This script creates the VMs in series, then
# provisions them in parallel.
#
# Try running this script instead of "vagrant up" when creating the VMs for the
# first time.
#
# source:
# http://joemiller.me/2012/04/26/speeding-up-vagrant-with-parallel-provisioning/
 
MAX_PROCS=4
 
# start boxes sequentially to avoid vbox explosions
vagrant up --no-provision
 
# initiate provision tasks to run in parallel
for i in $(seq 1 ${VAGRANT_DSE_NODES=1})
do
  box=dse1$((i-1))
  echo "Provisioning '$box'. Output will be in: $box.out.txt" 1>&2
  echo $box
done | xargs -P $MAX_PROCS -I"BOXNAME" sh -c 'vagrant provision BOXNAME >BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
