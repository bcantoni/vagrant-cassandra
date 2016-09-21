## 4.DSE Template

This Vagrant template sets up DataStax Enterprise (DSE) on a configurable number of VMs:

* dse[0-n] - DSE nodes (with prerequisites and DSE already installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM.
* This Vagrantfile will install the latest production version of DSE

## Instructions

### Setup

To use DSE you will need to register at [DataStax](https://www.datastax.com/download). This process will give you a username and password which enable free use of DSE in development environments.

Assuming you already have Vagrant installed, you can bring up the DSE nodes with the following:

```
$ export VAGRANT_DSE_USERNAME=your-username
$ export VAGRANT_DSE_PASSWORD=your-password
$ # optional: adjust DSE_NODES value in Vagrantfile (default 3)
$ vagrant up
```

When the up command is done, you can check the status of the VMs:

```
$ vagrant status
Configured for 3 DSE node(s)
Current machine states:

dse0           running (virtualbox)
dse1           running (virtualbox)
dse2           running (virtualbox)
```

```
$ vagrant ssh dse0
vagrant@dse0:~$ nodetool status
Datacenter: Cassandra
=====================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address      Load       Tokens  Owns    Host ID                               Rack
UN  10.10.10.12  83.1 KB    1       ?       a0376d25-e955-41f0-b098-e8ad30d2c530  rack1
UN  10.10.10.10  77.35 KB   1       ?       a9720ccb-2871-4b64-b565-18e517820a9b  rack1
UN  10.10.10.11  61.6 KB    1       ?       27661981-be43-4de8-8b16-3e322e948855  rack1
```

### Configure DSE

The default configuration will join all nodes together into a single cluster (with dse0 as the seed node) and start the services. For reference, see the [DataStax Enterprise documentation](https://docs.datastax.com/en/latest-dse/datastax_enterprise/production/initDSETOC.html) for all the details on DSE configuration settings.

Mac users might find [bcantoni/i2cssh](https://github.com/bcantoni/i2cssh) helpful. It will connect with all Vagrant nodes in parallel iTerm2 shell windows: `i2cssh -v`.

### Shut Down

To cleanly shut down all VMs, use the `down.sh` script:

```
$ ./down.sh
```

To destroy all VMs:

```
$ vagrant destroy -f
```
