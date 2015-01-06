## 5.Installer Template

This Vagrant template sets up DataStax Enterprise (DSE) on a configurable number of VMs using the DataStax Standalone Installer:

* dse10, dse11, etc. - DSE nodes (with prerequisites and DSE already installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM.
* Mac users might find [bcantoni/i2cssh](https://github.com/bcantoni/i2cssh) helpful. It will connect with all Vagrant nodes in parallel iTerm2 shell windows: `i2cssh -v`. (Make sure to set VAGRANT_DSE_NODES in `~/.profile` first.)

## Instructions

### Setup

To use DSE you will need to register at [DataStax](http://www.datastax.com/download). This process will give you a username and password which enable free use of DSE in development environments.

Next you will need to download the Standalone Installer from the [DataStax download page](http://www.datastax.com/download). Save it in the `vagrant-cassandra/5.Installer` directory. The downloaded file should be named `DataStaxEnterprise-4.6-linux-x64-installer.run` for DSE 4.6. (For older or newer versions, modify the INSTALLER_FILENAME setting in Vagrantfile.) 

If you want to script the installer download step, you can use wget like:

```
wget http://downloads.datastax.com/enterprise/DataStaxEnterprise-4.6-linux-x64-installer.run --user=your-username --password=your-password
```

### Create VM Cluster

Now you can bring up the DSE nodes with the following:

```
$ export VAGRANT_DSE_USERNAME=your-username
$ export VAGRANT_DSE_PASSWORD=your-password
$ export VAGRANT_DSE_NODES=3
$ ./up-parallel.sh
```

This will bring up each Vagrant VM in series and then provision each in parallel. (You could instead use the normal `vagrant up` which will build each VM in series and will be slower.)

Make sure to read the Unattended Install section below which explains what just happened.

When the up command is done, you can check the status of the VMs:

```
$ vagrant status
Building 3 DSE node(s)
Current machine states:

dse10           running (virtualbox)
dse11           running (virtualbox)
dse12           running (virtualbox)
```

Then login to one node and make sure the cluster is up and running:

```
$ vagrant ssh dse10
vagrant@dse10:~$ nodetool status
Datacenter: Cassandra
=====================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address      Load       Tokens  Owns   Host ID                               Rack
UN  10.10.11.12  85.32 KB   256     33.4%  27d44519-56c2-4da6-b0e6-77ef27c83e80  rack1
UN  10.10.11.10  68.63 KB   256     32.7%  a09e0151-3665-4a9b-bd00-beaeb08891ee  rack1
UN  10.10.11.11  88.92 KB   256     33.9%  9ea12f48-1751-4b68-8394-5a851effb5bd  rack1
```

### Unattended Install

This Vagrant template uses the unattended mode of the DSE installer. After the installer file is downloaded locally on the host, it will be available under the `/vagrant` directory inside the guest. The provisioning script will run the installer in unattended mode and pass a few options:

* mode: unattended (enable unattended mode)
* update_system: 0 (don't update any system packages)
* seeds: 10.10.11.10 (dse10 node)
* interface: 10.10.11.x (this node's IP address)
* start_services: 1 (start DSE service after install)

Installer options can also be defined in a properties file which is then passed on the command line.

Refer to these documentation pages for more details on the available options:

* [Unattended DataStax Enterprise installer documentation](http://www.datastax.com/documentation/datastax_enterprise/4.6/datastax_enterprise/install/installSilent.html)
* [DataStax Enterprise 4.6 documentation](http://www.datastax.com/documentation/datastax_enterprise/4.6/datastax_enterprise/deploy/deploySingleDC.html)

### Unattended Uninstall

The DSE installer also has a corresponding uninstaller. Refer to the [unattended uninstaller documentation](http://www.datastax.com/documentation/datastax_enterprise/4.6/datastax_enterprise/install/installremove.html) for more details.

To try this on a node, follow this example which will not drain the node (do_drain=0), but will remove all Cassandra data along with the services (full_uninstall=1):

```
$ vagrant ssh dse10
vagrant@dse10:~$ cd /usr/share/dse
vagrant@dse10:/usr/share/dse$ sudo cp /vagrant/uninstall.property .
vagrant@dse10:/usr/share/dse$ cat uninstall.property
do_drain=0
full_uninstall=1
vagrant@dse10:/usr/share/dse$ sudo ./uninstall --mode unattended
```

### Shut Down

To cleanly shut down all VMs, use the `down.sh` script:

```
$ ./down.sh
```

To destroy all VMs:

```
$ vagrant destroy -f
```
