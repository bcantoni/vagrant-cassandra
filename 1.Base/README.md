## 1.Base Template

This is a base Vagrant template that starts with only Java pre-installed. Follow the instructions below to try a couple different ways of installing Cassandra and DataStax.

## Instructions

### Setup

If everything has been installed correctly, you can bring up the Vagrant VM with the following:

```
$ vagrant up
```

The process will take a few minutes to create the VM and load the initial packages. When the up command is done, login to the VM and confirm that Java is installed:

```
$ vagrant ssh
vagrant@base:~$ java -version
java version "1.7.0_55"
OpenJDK Runtime Environment (IcedTea 2.4.7) (7u55-2.4.7-1ubuntu1~0.12.04.2)
OpenJDK 64-Bit Server VM (build 24.51-b03, mixed mode)
```

### Cassandra (Tarball)

First let's try installing Cassandra from the Tarball. These steps are patterned after the Cassandra [Getting Started][gs] page.

1. From the [Cassandra project site][dl] find the current release tarball (as of this writing, it's `apache-cassandra-2.0.8-bin.tar.gz`)
1. Click the link to find a suitable mirror link and copy it
1. From inside the VM, download and expand:

        $ wget http://apache.mirrors.pair.com/cassandra/2.0.8/apache-cassandra-2.0.8-bin.tar.gz
        $ tar xvzf apache-cassandra-2.0.8-bin.tar.gz
        $ cd apache-cassandra-2.0.8

1. Next create the data and log directories for Cassandra

        $ sudo mkdir /var/lib/cassandra
        $ sudo mkdir /var/log/cassandra
        $ sudo chown -R $USER:$GROUP /var/lib/cassandra
        $ sudo chown -R $USER:$GROUP /var/log/cassandra

1. Now we'll start Cassandra (as a background process) and make sure it's running with `cqlsh`, the interactive CQL shell:

        $ bin/cassandra
        $ bin/cqlsh
        Connected to Test Cluster at localhost:9160.
        [cqlsh 4.1.1 | Cassandra 2.0.8 | CQL spec 3.1.1 | Thrift protocol 19.39.0]
        Use HELP for help.

To exercise and play further with Cassandra, go through the [Getting Started][gs] walk-through.

To clean up from this step, stop Cassandra and remove the data directories:

        $ pkill -f CassandraDaemon
        $ sudo rm -rf /var/lib/cassandra
        $ sudm rm -rf /var/log/cassandra

### DataStax Community Edition (Ubuntu Package)

Next we'll try installing the [DataStax Community Edition][dsc] using the Ubuntu packages.

1. The first step is to add the DataStax repo to the sources list for APT:

        $ echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
        $ curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
        $ sudo apt-get update

1. Next, install the DataStax build:

        $ sudo apt-get install dsc20

1. When the installation is complete, Cassandra should be installed and running as a service.

        $ sudo service cassandra status
         * Cassandra is running
        $ nodetool status
        Datacenter: datacenter1
        =======================
        Status=Up/Down
        |/ State=Normal/Leaving/Joining/Moving
        --  Address    Load       Tokens  Owns (effective)  Host ID                               Rack
        UN  127.0.0.1  40.94 KB   256     100.0%            e3c5a74b-b29c-4084-9621-50c169c75cb7  rack1
        vagrant@base:~$ cqlsh
        Connected to Test Cluster at localhost:9160.
        [cqlsh 4.1.1 | Cassandra 2.0.8 | CQL spec 3.1.1 | Thrift protocol 19.39.0]
        Use HELP for help.
        cqlsh>


[gs]: http://wiki.apache.org/cassandra/GettingStarted
[dl]: http://cassandra.apache.org/download/
[dsc]: http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installDeb_t.html


name: base

go thru:

installs, point to docs
cassandra tar

dsc apt-get
opscenter + agent

simple walk-thru with
- nodetool status
- cqlsh
  create keyspace
  create table
  insert data
  select data

point to walk-thru docs
