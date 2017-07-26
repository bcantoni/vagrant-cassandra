# Vagrant Cassandra

This project contains templates for learning how to install and configure [Apache Cassandra](https://cassandra.apache.org/) or [DataStax Enterprise](https://www.datastax.com/products/datastax-enterprise) (DSE) on a local dev machine. It uses [Vagrant](http://www.vagrantup.com/) to configure and run virtual machines (VMs) running in [VirtualBox](https://www.virtualbox.org/). Vagrant enables quickly building environments in a way that is repeatable and isolated from your host system. This makes it perfect for experimenting with different configurations of Cassandra and DSE.

Why create yet another Cassandra on Vagrant system? Many scripts and Vagrant projects are already fully assembled and configured. Instead, I like to learn from the ground up so I can better understand each step. In the templates below I've also tried to minimize external dependencies, and the number of tools which need to be installed. (For example, I don't use Chef or Puppet here.)

## Related Projects

Here are a few related projects I learned from while assembling my Vagrant setup:

* [calebgroom/vagrant-cassandra](https://github.com/calebgroom/vagrant-cassandra) - uses Chef to quickly create a 3-node cluster
* [dholbrook/vagrant-cassandra](https://github.com/dholbrook/vagrant-cassandra) - another Chef
* [oeelvik/vagrant-puppet-hadoop-datastax](https://github.com/oeelvik/vagrant-puppet-hadoop-datastax) - using Puppet for provisioning
* [cjohannsen81/dse-vagrant](https://github.com/cjohannsen81/dse-vagrant) - similar to my approach, just using script provisioning

You may also find [bcantoni/vagrant-deb-proxy](https://github.com/bcantoni/vagrant-deb-proxy) helpful for speeding up Ubuntu package installs. See Package Caching below for details.

Posts from my blog related to this project:

* [Using Vagrant for Local Cassandra Development](http://www.cantoni.org/2014/08/26/vagrant-cassandra)
* [DataStax Installer with Vagrant](http://www.cantoni.org/2015/01/05/datastax-installer-vagrant)

## Screencasts

Here are some quick screencasts which walk through the three different templates in this project:

### 1. Base
[![Vagrant Cassandra Single Node Screencast](http://img.youtube.com/vi/tjNLQNYd3Rc/0.jpg)](http://www.youtube.com/watch?v=tjNLQNYd3Rc)

### 2. MultiNode
[![Vagrant Cassandra Multi Node Screencast](http://img.youtube.com/vi/xaVqvNeNlKM/0.jpg)](http://www.youtube.com/watch?v=xaVqvNeNlKM)

### 3. MultiDC
[![Vagrant Cassandra Multi Datacenter Screencast](http://img.youtube.com/vi/rTGSfmpgqP0/0.jpg)](http://www.youtube.com/watch?v=rTGSfmpgqP0)

## Installation

Note: These scripts were created on a Mac OS X 10.9/10.10/10.11 host with Vagrant v1.6/1.7 and VirtualBox v4.3/5.0. Everything should work for Linux or Windows hosts as well, but I have not tested those platforms. Shell scripts which are meant to run on the host (like up-parallel.sh or down.sh) would need to have Windows equivalents created.

1. Edit your local Hosts file to include the private network addresses (this makes it much easier to refer to the VMs by hostname):

        # vagrant-cassandra private network hosts
        10.211.54.10    cassandra
        10.10.10.10     dse0
        10.10.10.11     dse1
        10.10.10.12     dse2
        10.10.10.13     dse3
        10.10.10.14     dse4
        10.10.11.10     dse10
        10.10.11.11     dse11
        10.10.11.12     dse12
        10.10.11.13     dse13
        10.10.11.14     dse14
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

   Alternatively, try the [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin which should do the same thing automatically. (I have not tried it.)
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant](https://www.vagrantup.com/downloads.html)
1. Check that both are installed and reachable from a command line:

        $ vagrant --version
        Vagrant 1.7.4
        $ VBoxManage --version
        5.0.8r103449

1. Clone this repository

        $ git clone https://github.com/bcantoni/vagrant-cassandra.git
        $ cd vagrant-cassandra

1. Try each of the templates listed below, for example:

        $ cd 1.Base
        $ vagrant up
        $ vagrant ssh

## Package Caching

These Vagrant files are configured to use a Debian/Ubuntu APT cache if configured. This can make the provisioning step faster and less susceptible to Ubuntu repository connection speeds.

If you want to run your own locally (through Vagrant), take a look at [bcantoni/vagrant-deb-proxy](https://github.com/bcantoni/vagrant-deb-proxy).

To enable package caching, set the `DEB_CACHE_HOST` environment variable before creating the Vagrant VMs, for example:

    $ export DEB_CACHE_HOST="http://10.211.54.100:8000"
    $ vagrant up

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

### [1. Base](1.Base)

This is a base template with only Java pre-installed. It's a good getting started point to explore installing Cassandra and DataStax packages.

### [1. Base CentOS](1.Base.CentOS)

Same as above, but using CentOS instead of Ubuntu.

### [2. MultiNode](2.MultiNode)

This template creates 4 VMs: one for OpsCenter and 3 for Cassandra nodes. OpsCenter is preinstalled, and you can use that to finish building the cluster.

### [3. MultiDC](3.MultiDC)

This template builds and configures a multi-datacenter cluster (one OpsCenter VM and 6 Cassandra nodes in 2 logical datacenters).

### [4. DSE](4.DSE)

This template focuses on DataStax Enterprise (DSE) and can build a variable number of nodes in a cluster.

### [5. Installer](5.Installer)

This template is structurally the same as 4.DSE, but instead uses the Standalone Installer which first came out with DSE 4.5.

## Notes

* Most templates are currently based off the `ubuntu/trusty64` box which is running 64-bit Ubuntu 14.04 LTS. You can change the `vm.box` value if you want to try different guest operating systems.

# License

Copyright 2014-17 Brian Cantoni

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
