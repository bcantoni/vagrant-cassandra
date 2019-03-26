## 1.Base Template

This is a base Vagrant template that starts with only Java pre-installed. Follow the instructions below to try a couple different ways of installing Apache Cassandra and DataStax Enterprise.

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
openjdk version "1.8.0_171"
OpenJDK Runtime Environment (build 1.8.0_171-8u171-b11-2~14.04-b11)
OpenJDK 64-Bit Server VM (build 25.171-b11, mixed mode)
```

### Cassandra (Tarball)

First let's try installing Apache Cassandra from the tarball. These steps are patterned after the Cassandra [Getting Started][gs] page.

1. From the [Cassandra project site][dl] find the current 2.x release tarball (as of this writing, it's `apache-cassandra-2.2.14-bin.tar.gz`)
1. Click the link to find a suitable mirror link and copy it
1. From inside the VM, download and expand:

        $ wget http://apache.mirrors.pair.com/cassandra/2.2.14/apache-cassandra-2.2.14-bin.tar.gz
        $ tar xvzf apache-cassandra-*-bin.tar.gz
        $ cd apache-cassandra-*

1. Now we'll start Cassandra (as a background process) and make sure it's running with `cqlsh`, the interactive CQL shell:

        $ bin/cassandra
        $ bin/cqlsh
        Connected to Test Cluster at localhost:9160.
        [cqlsh 4.1.1 | Cassandra 2.0.8 | CQL spec 3.1.1 | Thrift protocol 19.39.0]
        Use HELP for help.
        cqlsh>

1. Try some [CQL](http://cassandra.apache.org/doc/latest/cql/) commands:

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
    [cqlsh 5.0.1 | Cassandra 2.2.14 | CQL spec 3.3.1 | Native protocol v4]
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

### DataStax Distribution of Apache Cassandra

Next we'll try installing the [DataStax Distribution of Apache Cassandra][ddac] using the tarball.

1. From the [DataStax Academy downloads page][dsa] find and download the current release tarball (as of this writing, it's `ddac-5.1.13-bin.tar.gz`)
1. Move the ddac tarball into the 1.Base directory
1. From inside the VM, download and expand:

        $ tar xvzf /vagrant/ddac-*-bin.tar.gz
        $ cd ddac-*

1. Next create the data and log directories for Cassandra

        $ sudo mkdir /var/{lib,log}/cassandra
        $ sudo chown -R $USER:$GROUP /var/{lib,log}/cassandra

1. Now we'll start Cassandra (as a background process) and make sure it's running with `cqlsh`, the interactive CQL shell:

        $ bin/cassandra
        $ bin/cqlsh
        Connected to Test Cluster at localhost:9160.
        [cqlsh 4.1.1 | Cassandra 2.0.8 | CQL spec 3.1.1 | Thrift protocol 19.39.0]
        Use HELP for help.
        cqlsh>

Now you can play with Cassandra as we did before, using the CQLSH tool. The difference here is the install method (Ubuntu package versus tarball), and the result is Cassandra running as a service automatically.

[gs]: https://cassandra.apache.org/doc/latest/getting_started/index.html
[dl]: https://cassandra.apache.org/download/
[ddac]: https://www.datastax.com/products/datastax-distribution-of-apache-cassandra
[dsa]: https://academy.datastax.com/downloads
