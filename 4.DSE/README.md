## 4.DSE Template

This Vagrant template sets up DataStax Enterprise (DSE) on a configurable number of VMs:

* dse[0-n] - DSE nodes (with prerequisites and DSE already installed)

Notes:

* Depending on how much memory your host system has, you may need to lower the default memory size for each VM. Currently it's set to 3GB for each VM.

## Instructions

### Setup

To use DSE you will need to register at [DataStax](http://www.datastax.com/download). This process will give you a username and password which enable free use of DSE in development environments.

Assuming you already have Vagrant installed, you can bring up the 4 VMs with the following:

```
$ export VAGRANT_DSE_USERNAME=your-username
$ export VAGRANT_DSE_PASSWORD=your-password
$ export VAGRANT_DSE_NODES=3
$ vagrant up
```

When the up command is done, you can check the status of the VMs:

```
$ vagrant status
Building 3 DSE node(s)
Current machine states:

dse0                     running (virtualbox)
dse1                     running (virtualbox)
dse2                     running (virtualbox)
```

### Configure DSE

Now you'll have an N-node cluster of DSE which needs to be configured.

Mac users might find [bcantoni/i2cssh](https://github.com/bcantoni/i2cssh) helpful. It will connect with all Vagrant nodes in parallel iTerm2 shell windows: `i2cssh -v`.

For reference, see the [DataStax Enterprise 4.5 documentation](http://www.datastax.com/documentation/datastax_enterprise/4.5/datastax_enterprise/deploy/deploySingleDC.html) if you aren't familiar with DSE configuration settings.

### Shut Down

To cleanly shut down all VMs (example for 3 nodes):

```
$ for i in {0..2}; do vagrant ssh dse$i -c 'sudo shutdown -h now'; done
```

To destroy all 4 VMs:

```
$ vagrant destroy -f
```
