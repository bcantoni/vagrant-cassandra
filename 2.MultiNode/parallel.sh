#!/bin/sh

# Vagrant Cassandra Project
# Brian Cantoni
#
# Provisioning several VMs at once can be pretty slow depending on the speed of
# the Ubuntu mirrors at the time. This script creates the 3 VMs in series, then
# provisions them in parallel.
#
# Try running this script instead of "vagrant up" when creating the VMs for the
# first time.
#
# source:
# http://joemiller.me/2012/04/26/speeding-up-vagrant-with-parallel-provisioning/
 
MAX_PROCS=4
 
parallel_provision() {
    while read box; do
        echo "Provisioning '$box'. Output will be in: $box.out.txt" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
}
 
## -- main -- ##
 
# start boxes sequentially to avoid vbox explosions
vagrant up --no-provision
 
# but run provision tasks in parallel
cat <<EOF | parallel_provision
node0
node1
node2
node3
EOF