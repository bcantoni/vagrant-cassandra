# 3.MultiDC Template

This Vagrant template sets up 6 separate VMs for creating a multi-datacenter Apache Cassandra cluster:

* node[11-16] - [Cassandra](https://cassandra.apache.org/) nodes

The Vagrantfile in this example creates the VMs, installs Cassandra, then configures the 6-node cluster into two different logical datacenters (DC1 and DC2).

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 1400 MB for each VM, but with all 6 running it may be too much for your host. You could lower SERVER_COUNT in Vagrantfile if needed.

## Instructions

### Setup

If Vagrant has been installed correctly, you can bring up the 6 VMs with the following:

```
$ ./up-parallel.sh
```

Note: This will bring up each VM in series and then provision each in parallel. You can also just run `vagrant up` which does everything in series and will be slower.

When the provisioning process is done, you can check the status of the VMs:

```
$ vagrant status
Current machine states:

node11                     running (virtualbox)
node12                     running (virtualbox)
node13                     running (virtualbox)
node14                     running (virtualbox)
node15                     running (virtualbox)
node16                     running (virtualbox)
```

Log in to one node and check the Cassandra cluster status. You should see all 6 nodes up and running:

```
$ vagrant ssh node11
$ nodetool status
Datacenter: DC1
===============
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address        Load       Tokens  Owns (effective)  Host ID                               Rack
UN  10.211.55.113  86.26 KB   256     34.7%             f42d6001-9e74-4249-b510-35c4942ea059  RAC1
UN  10.211.55.115  69.56 KB   256     31.4%             b4f89779-d832-4c9e-9cde-03b116dfde0f  RAC1
UN  10.211.55.111  41.07 KB   256     33.3%             0454cb56-fd91-4857-8ce5-60cbf39a8ff3  RAC1
Datacenter: DC2
===============
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address        Load       Tokens  Owns (effective)  Host ID                               Rack
UN  10.211.55.116  69.92 KB   256     34.3%             37ee2707-e133-4557-9c14-577712f8e9d8  RAC1
UN  10.211.55.112  57.16 KB   256     33.0%             4830a1ad-88c2-4f8a-96a0-11480614c00e  RAC1
UN  10.211.55.114  65.56 KB   256     33.2%             6fda6f3f-8f94-4f80-a228-09d415dfd70f  RAC1
```

### Cassandra Versions

This template is currently set to install the latest Apache Cassandra 3.6.x. You can adjust the Cassandra version if needed in the Vagrantfile by adjusting the repo or the specific version number.

Note: This template originally also included OpsCenter. However, since [support was dropped for Apache Cassandra starting with OpsCenter 6.0](https://docs.datastax.com/en/opscenter/6.7/opsc/opscPolicyChanges.html), I've removed that from the project here.

### Shut Down

To cleanly shut down all VMs:

```
$ for i in {1..6}; do vagrant ssh node1$i -c 'sudo shutdown -h now'; done
```

To destroy all VMs:

```
$ vagrant destroy -f
```
