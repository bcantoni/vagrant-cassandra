# Vagrant Cassandra

This project contains templates for learning how to install and configure Cassandra/DataStax on a local dev machine. It uses [Vagrant](http://www.vagrantup.com/) to configure and run virtual machines (VMs) running in [VirtualBox](https://www.virtualbox.org/). Vagrant enables quickly building environments in a way that is repeatable and isolated from your host system. This makes it perfect for experimenting with different configurations of Cassandra/DataStax.

Why create yet another Cassandra on Vagrant system? Many scripts and Vagrant projects are already fully assembled and configured. Instead, I like to learn from the ground up so I can better understand each step. In the templates below I've also tried to minimize external dependencies, and the number of tools which need to be installed. (For example, I don't use Chef or Puppet here.)

## Related Projects

Here are a few related projects I learned from while assembling my Vagrant setup:

* [calebgroom/vagrant-cassandra](https://github.com/calebgroom/vagrant-cassandra) - uses Chef to quickly create a 3-node cluster
* [dholbrook/vagrant-cassandra](https://github.com/dholbrook/vagrant-cassandra) - another Chef
* [oeelvik/vagrant-puppet-hadoop-datastax](https://github.com/oeelvik/vagrant-puppet-hadoop-datastax) - using Puppet for provisioning

You may also find [bcantoni/vagrant-deb-proxy](https://github.com/bcantoni/vagrant-deb-proxy) helpful for speeding up Ubuntu package installs.

## Cassandra vs DataStax

In this project I tend to use the terms "Cassandra" and "DataStax" interchangeably. Here's the distinction:

* [Cassandra](http://cassandra.apache.org/) is the Apache open source database project. Their releases include binary .tar and packages for Debian
* [DataStax](http://datastax.com/) provides the Cassandra database combined with other tools in two flavors:
    * [DataStax Community](http://planetcassandra.org/cassandra/) - includes Cassandra, OpsCenter, demos, and installers for Linux, Windows, and Mac. This is free for everyone to use.
    * [DataStax Enterprise](http://www.datastax.com/what-we-offer/products-services/datastax-enterprise) - a commercial integrated product which includes Analytics (Hadoop) and Search (Solr) modules, on top of the basic Community edition. This build can be run for free in development (after registration). Using in production requires a paid license agreement which would then include support, training, and so on.

## Installation

Note: These scripts were created on a Mac OS X 10.9.4 host with Vagrant v1.6.3 and VirtualBox v4.3.12. Everything should work for Windows hosts as well, but I have not tested it yet.

1. Edit your local Hosts file to include the private network addresses (this makes it much easier to refer to the VMs by hostname):

        # vagrant-cassandra private network hosts
        10.211.54.10    cassandra
        10.211.55.100   node0
        10.211.55.101   node1
        10.211.55.102   node2
        10.211.55.103   node3
        10.211.55.110   node10
        10.211.55.111   node11
        10.211.55.112   node12
        10.211.55.113   node13
        10.211.55.114   node14
        10.211.55.115   node15
        10.211.55.116   node16

   Alternatively, try the [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin which should do the same thing automatically.
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant](https://www.vagrantup.com/downloads)
1. Install and start [bcantoni/vagrant-deb-proxy](https://github.com/bcantoni/vagrant-deb-proxy) to make the provisioning steps much faster
1. Check that both are installed and reachable from a command line:

        $ vagrant --version
        Vagrant 1.6.0
        $ VBoxManage --version
        4.3.12r93733

1. Clone this repository

        $ git clone https://github.com/bcantoni/vagrant-cassandra.git
        $ cd vagrant-cassandra

1. Try each of the templates listed below, for example:

        $ cd 1.Base
        $ vagrant up
        $ vagrant ssh

## Using Vagrant

The [Vagrant documentation](https://docs.vagrantup.com/v2/) is very good and I recommend going through the Getting Started section.

These are the most common commands you'll need with this project:

* `vagrant up` - Create and configure VM
* `vagrant ssh` - SSH into the VM
* `vagrant halt` - Halt the VM (power off)
* `vagrant suspend` - Suspend the VM (save state)
* `vagrant provision` - Run (or re-run) the provisioner script
* `vagrant destroy` - Destroy the VM

## Templates

These are the starting templates which go through increasing levels of complexity for a Cassandra installation. Each of these is located in its own subdirectory with its own `Vagrantfile` (the definition file used by Vagrant) and a README with instructions and more details.

### 1. Base

This is a base template with only Java pre-installed. It's a good getting started point to explore installing Cassandra and DataStax packages.

### 2. MultiNode

This template creates 4 VMs: one for OpsCenter and 3 for Cassandra nodes. OpsCenter is preinstalled, and you can use that to finish building the cluster.

### 3. MultiDC

This template builds and configures a multi-datacenter cluster (one OpsCenter VM and 6 Cassandra nodes in 2 datacenters).

## Notes

* All templates are currently based off the `hashicorp/precise64` box which is running 64-bit Ubuntu 12.04 LTS. You can change the `vm.box` value if you want to try different guest operating system versions (e.g. use `ubuntu/trusty64` for Ubuntu 14.04).
