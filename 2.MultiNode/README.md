## 2.MultiNode Template

This Vagrant template sets up 4 separate VMs for creating an Apache Cassandra cluster:

* node0 - [OpsCenter](http://www.datastax.com/what-we-offer/products-services/datastax-opscenter) host
* node[1-3] - base system (only Java pre-installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM, but with all 4 running it may be too much for your host.

## Instructions

### Setup

If Vagrant has been installed correctly, you can bring up the 4 VMs with the following:

```
$ ./up-parallel.sh
```

Note: This will bring up each VM in series and then provision each in parallel. You can also just run `vagrant up` which does everything in series and will be slower.

When the up command is done, you can check the status of the 4 VMs:

```
$ vagrant status
Current machine states:

node0                     running (virtualbox)
node1                     running (virtualbox)
node2                     running (virtualbox)
node3                     running (virtualbox)
```

The `vagrant ssh` command will let you login to one node at a time. You can also use a for loop to run a command on all 4 VMs, for example:

```
$ for i in {0..3}; do vagrant ssh node$i -c 'uname -a'; done
Linux node0 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Linux node1 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Linux node2 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
Linux node3 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
```

### OpsCenter

First, let's confirm that OpsCenter is running:

```
$ vagrant ssh node0 -c "sudo service opscenterd status"
 * Cassandra cluster manager opscenterd is running
```

Next, connect to the OpsCenter web interface: <http://node0:8888/> which should start like the following:

![OpsCenter Start Screenshot](images/OpsCenterStart.png)

Now we can use OpsCenter to create the cluster for us on node[1-3]. Click on Create Brand New Cluster and fill in the appropriate fields:

* Name: Change it or leave as default "Test Cluster"
* Package: DataStax Community 2.0.8
* Nodes: node1, node2, node3 (each on a new line)
* Node credentials: vagrant / vagrant

Click View Advanced Options to get a view of customizations you can control.

Click Build Cluster, then Accept Fingerprints.

OpsCenter will switch to the Build in Progress status page:

![Build in Progress Screenshot](images/BuildProgress.png)

Once all packages are installed and configured, the agents will start up up. Once all agents are running, OpsCenter will switch to the dashboard showing your 3-node cluster up and running: 

![Build Complete Screenshot](images/BuildComplete.png)

To put some load on the Cassandra cluster (and see the reaction in OpsCenter), try running the Cassandra Stress tool:

```
$ vagrant ssh node1
vagrant@node1:~$ cassandra-stress write n=200000 -node node1
Created keyspaces. Sleeping 1s for propagation.
Sleeping 2s...
Warming up WRITE with 50000 iterations...
Connected to cluster: Test Cluster
Datatacenter: Cassandra; Host: node1/10.211.55.101; Rack: rack1
Datatacenter: Cassandra; Host: /10.211.55.103; Rack: rack1
Datatacenter: Cassandra; Host: /10.211.55.102; Rack: rack1
Failed to connect over JMX; not collecting these stats
Running WRITE with 200 threads for 200000 iteration
Failed to connect over JMX; not collecting these stats
type,      total ops,    op/s,    pk/s,   row/s,    mean,     med,     .95,     .99,    .999,     max,   time,   stderr, errors,  gc: #,  max ms,  sum ms,  sdv ms,      mb
total,         10493,   10493,   10493,   10493,    18.1,    18.7,    36.1,    83.0,    91.0,    94.9,    1.0,  0.00000,      0,      0,       0,       0,       0,       0
total,         23344,   12287,   12287,   12287,    16.3,    16.6,    35.2,    46.5,    56.3,    66.0,    2.0,  0.05571,      0,      0,       0,       0,       0,       0
total,         35805,   11591,   11591,   11591,    17.2,    15.5,    40.9,   112.6,   144.7,   151.0,    3.1,  0.04204,      0,      0,       0,       0,       0,       0
total,         50354,   14282,   14282,   14282,    14.0,    14.9,    28.2,    32.7,    39.2,    56.0,    4.1,  0.05430,      0,      0,       0,       0,       0,       0
...
```

From here, you can learn more about OpsCenter:

* [OpsCenter Tutorial](https://www.datastax.com/resources/tutorials/overview-opscenter) (video)
* [OpsCenter Documentation](https://docs.datastax.com/en/opscenter/5.2/opsc/about_c.html)
* [Using OpsCenter](https://docs.datastax.com/en/opscenter/5.2/opsc/online_help/opscUsing_g.html)


### Shut Down

To cleanly shut down all 4 VMs:

```
$ for i in {0..3}; do vagrant ssh node$i -c 'sudo shutdown -h now'; done
```

To destroy all 4 VMs:

```
$ vagrant destroy -f
```
