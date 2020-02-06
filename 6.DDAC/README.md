# 4.DDAC Template

This Vagrant template sets up DataStax Distribution of Apache Cassandra (DDAC) on a configurable number of VMs:

* node[0-n] - DDAC nodes (with prerequisites and DDAC already installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM.
* This Vagrantfile assumes the current DDAC tarball has been downloaded locally into this directory.

## Instructions

### Setup

Assuming you already have Vagrant installed, you can bring up the DDAC nodes with the following:

```
$ # optional: adjust NODES value in Vagrantfile (default 3)
$ vagrant up
```

When the up command is done, you can check the status of the VMs:

```
$ vagrant status
Configured for 3 node(s)
Current machine states:

node0                     running (virtualbox)
node1                     running (virtualbox)
node2                     running (virtualbox)
```

```
$ vagrant ssh node0
vagrant@node0:~$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address        Load       Tokens       Owns (effective)  Host ID                               Rack
UN  10.211.55.102  74.95 KiB  256          69.0%             d4f41d2c-0824-488b-8eab-66c86a472f8e  rack1
UN  10.211.55.101  88.62 KiB  256          66.3%             5ed5ba19-e9df-4732-bb54-27247a1f1af7  rack1
UN  10.211.55.100  108.47 KiB  256          64.6%             fd5a9e7e-5ef7-41e9-b5b9-de2159cc860a  rack1
```

### Configure DDAC

The default configuration will join all nodes together into a single cluster (with node0 as the seed node) and start the database on each node. Note that it's not installed as a service, so if the nodes are shutdown or restarted, Cassandra will need to be manually restarted as well.

### Shut Down

To destroy all VMs:

```
$ vagrant destroy -f
```
