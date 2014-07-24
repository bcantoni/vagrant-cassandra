## 1.Base Template

This is a base Vagrant template that starts with only Java pre-installed. Follow the instructions below to try a couple different ways of installing Cassandra and DataStax.

## Instructions

### Setup

If Vagrant and VirtualBox have been installed correctly, you can bring up the Vagrant VM with the following:

```
$ vagrant up
```

The process will take several minutes to create the VM and load the initial packages. For the very first run, the download will take a while as the whole Ubuntu image is downloaded to your system. Future "ups" will be much faster.

When the up command is done, login to the VM and confirm that Java is installed:

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
        cqlsh>

1. Try some [CQL](http://www.datastax.com/documentation/cql/3.1/cql/cql_intro_c.html) commands:

        CREATE KEYSPACE usertest WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

        USE usertest;

        CREATE TABLE users (
          user_id int,
          fname text,
          lname text,
          email text,
          primary key (user_id)
        );

        INSERT INTO users (user_id, fname, lname, email) VALUES (1000, 'john', 'smith', 'smith_j@example.com');
        INSERT INTO users (user_id, fname, lname, email) VALUES (1001, 'john', 'doe', 'john.doe@example.com');
        INSERT INTO users (user_id, fname, lname, email) VALUES (1002, 'bob', 'johnson', 'bob@example.com');

        SELECT * FROM users;

To exercise and play further with Cassandra, go through the [Getting Started][gs] walk-through. To load the table with more data, there is a sample data CSV file which can be imported using the CQL shell:

    $ cqlsh
    Connected to Test Cluster at localhost:9160.
    [cqlsh 4.1.1 | Cassandra 2.0.8.39 | CQL spec 3.1.1 | Thrift protocol 19.39.0]
    Use HELP for help.
    cqlsh> COPY usertest.users (user_id, email, lname, fname) FROM '/vagrant/sample_users.csv' WITH HEADER = true;
    100 rows imported in 0.173 seconds.
    cqlsh> select count(*) from usertest.users;

     count
    -------
       103

    (1 rows)

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

Now you can play with Cassandra as we did before, using the CQLSH tool. The difference here is the install method (Ubuntu package versus tarball), and the result is Cassandra running as a service automatically.

[gs]: http://wiki.apache.org/cassandra/GettingStarted
[dl]: http://cassandra.apache.org/download/
[dsc]: http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installDeb_t.html
