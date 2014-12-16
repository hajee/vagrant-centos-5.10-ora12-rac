
#Oracle 12c RAC cluster

This repository contains a proof of concept for installing an Oracle 12c RAC cluster  Puppet.  We use Vagrant to show you how to do it. Based on the information in this repo, you should be able to use the [`ora_rac`](https://github.com/hajee/ora_rac) puppet module to build your own RAC environment.

#Get started
To get started, you need the following stuff:
- Vagrant installed and running
- A Vagrant image for CentOS 5 update 10 with Puppet 3.6 or higher installed.
- The software installation files for Oracle 12.1.0.1.0
- The software installation files for Oracle Grid 12.1.0.1.0
- The packages for oracleasm
- The Puppet modules

##Vagrant installed and running
You can get vagrant from the [vagrant web site](https://www.vagrantup.com/). 

##Vagrant image
The puppet classes and manifests in this repository are  tested on a CentOS 5.10 box with Puppet.  To be sure, you don't run into box differences; we have put up [our box on the vagrantcloud](https://vagrantcloud.com/hajee/boxes/centos-5.10-x86_64). It is not a very special box. It's just a box with Puppet V3.6.2 installed. So if you want to try it on another box, you can, just be sure you have Puppet installed.

##The Oracle 12.1.0.1.0 installation files
 The Oracle zip files are not part of this repository. You **MUST** provide them yourself. You can find them at [the Oracle download web site](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html). This Vagrant box uses the following zip files:
 - linuxamd64_12c_database_1of2.zip
 - linuxamd64_12c_database_2of2.zip

To get started, you need to create a folder software and put those zip's and there.

##The Grid 12.1.0.1.0 installation files
 The Grid zip files are not part of this repository. You **MUST** provide them yourself. You can find them at [the Oracle download web site](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html). This Vagrant box uses the following zip files:
 - linuxamd64_12c_grid_1of2.zip
 - linuxamd64_12c_grid_2of2.zip

To get started, you need to create a folder software and put those zip's and there.

##The packages for oracleasm
Like the Oracle installer zip files, you need to download these files yourself. You can find them at [the Oracle download page](http://www.oracle.com/technetwork/server-storage/linux/downloads/rhel5-084877.html)


For ASM, you need to download:
- [oracleasm-2.6.18-371.el5-2.0.5-1.el5.x86_64.rpm](http://oss.oracle.com/projects/oracleasm/dist/files/RPMS/rhel5/amd64/2.0.5/2.6.18-371.el5/oracleasm-2.6.18-371.el5-2.0.5-1.el5.x86_64.rpm)
- [oracleasm-support-2.1.8-1.el5.x86_64.rpm](http://oss.oracle.com/projects/oracleasm-support/dist/files/RPMS/rhel5/amd64/2.1.8/oracleasm-support-2.1.8-1.el5.x86_64.rpm)
- [oracleasmlib-2.0.4-1.el5.x86_64.rpm](http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.4-1.el5.x86_64.rpm)

You need to put those rpm's into the software folder too.

**WATCH IT** If you want to run it on a different kernel, you need other RPM's


##The Puppet modules

The installation of RAC is based on the excellent modules from Edwin Biemond. You can find them at [github](https://github.com/biemond/biemond-oradb). To make installation easier, we have automated the installation of all Puppet modules, by providing a `Puppetfile`. To install all modules, use:

```
$ bundle exec rake install_modules
```

This will download the latest released version of the required modules and put them at the right spot. If `rake` doesn't work and you don't know what it is, check [the description of the tools you neeed](#the-tools-to-get-it-working)


#Run the virtual machines


Before you can start, your directory should look like this:

```
|-- puppet
|   |-- hiera.yaml
|   |-- hieradata
|   |   |-- hosts
|   |   `-- instances
|   |       `-- example.yaml
|   |-- manifests
|   |   `-- site.pp
|   `-- modules
|       |-- augeasproviders
|       |   |-- ...
|       |   |-- ...
|       |-- boolean
|       |   |-- ...
|       |   |-- ...
|       |-- easy_type
|       |   |-- ...
|       |   |-- ...
|       |-- filemapper
|       |   |-- ...
|       |   |-- ...
|       |-- firewall
|       |   |-- ...
|       |   |-- ...
|       |-- fw
|       |   |-- ...
|       |   |-- ...
|       |-- hacks
|       |   |-- ...
|       |   |-- ...
|       |-- limits
|       |   |-- ...
|       |   |-- ...
|       |-- netstdlib
|       |   |-- ...
|       |   |-- ...
|       |-- network
|       |   |-- ...
|       |   |-- ...
|       |-- ora_rac
|       |   |-- ...
|       |   |-- ...
|       |-- oracle
|       |   |-- ...
|       |   |-- ...
|       |-- oradb
|       |   |-- ...
|       |   |-- ...
|       |-- partition
|       |   |-- ...
|       |   |-- ...
|       |-- ssh
|       |   |-- ...
|       |   |-- ...
|       |       `-- init.pp
|       `-- stdlib
|       |   |-- ...
|       |   |-- ...
|
|-- software
|   |-- oracleasm-2.6.18-371.el5-2.0.5-1.el5.x86_64.rpm
|   |-- oracleasm-support-2.1.8-1.el5.x86_64.rpm
|   |-- oracleasmlib-2.0.4-1.el5.x86_64.rpm
|   |-- p13390677_112040_Linux-x86-64_1of7.zip
|   |-- p13390677_112040_Linux-x86-64_2of7.zip
|   `-- p13390677_112040_Linux-x86-64_3of7.zip
```


The Oracle RAC installation includes two Vagrant virtual machines and shared SCSI storage. To get this all running, you need to do stuff in a specific order. To make it easy for you, we have provided rake tasks to do all the work for you. To get the whole shebang up and running, use:

```
$ bundle exec rake db; bundle exec rake up; bundle exec rake provision
```

##rake db
This rake task, creates the shared disks needed for the RAC installation. It creates's both machines and connects the disks to both machines. After these tasks, all machines are shutdown.

#rake up
This rake task starts both machines but doesn't start the provisioning. This is a required because, during the deployment of the database master, the others servers need te be available at IP-level.

##rake provision
This rake tasks, run's the Puppet manifests. First on node `db1`, then on node `db2`. Node `db1` is the database master and node `db2` is a database server. The database server is placed into a running single node RAC cluster (e.g. `db1`)

#Configure your own stuff
Most configuration is done in file `puppet\hieradata\instances\example.yaml`
```yaml
ora_rac::params::db_name:            EXAMPLE
ora_rac::params::db_machines:
  db1:
    ip:    172.16.10.20
    priv:  172.17.10.20
    vip:   172.16.10.21
  db2:
    ip:    172.16.10.30
    priv:  172.17.10.30
    vip:   172.16.10.31

ora_rac::params::domain_name:        example.com
ora_rac::params::scan_name:          scan
ora_rac::params::scan_adresses:
  - '172.16.10.40'
  - '172.16.10.41'
  - '172.16.10.42'
```
- To change the database name, change parameter `ora_rac::params::db_name`.
- To change the node names, change the keys of the hash in `ora_rac::params::db_machines`.
- to change the used IP addresses, change the IP addresses in the `ora_rac::params::db_machines`.
- To add an extra node, Add an extra entry to `ora_rac::params::db_machines`

#Clean up
To clean up the two machines you can use the rake task ` destroy`:

```
$ bundle exec rake destroy
```


#The Tools to get it working
Installing a RAC cluster is a complex set of operations. We have used Puppet to make it more manageable. But to make it even easier, we've used `rake`. `Rake` is a tool that is widly used in the ruby world.  Using `rake` is easy. But getting it installed, takes some effort. To get it running, you need a ruby version of 1.9 or higher. You can check this by:

````
$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
```
You also need the `bundler` tool. This tool takes care that all required ruby libraries are loaded. You can install it with:

````
$ gem install bundler
Fetching: bundler-1.7.3.gem (100%)
Successfully installed bundler-1.7.3
Parsing documentation for bundler-1.7.3
Installing ri documentation for bundler-1.7.3
Done installing documentation for bundler after 1 seconds
1 gem installed
```
 Now we can ask `bundler` to install a required ruby gems:

```
$ bundle install
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using rake 10.3.2
...
Using librarian-puppet 1.3.2
Using bundler 1.7.3
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

To be sure all commands run within the specified set of gems, you need to prepend the commands with ` bundle exec`.




_______










#Oracle 12 RAC cluster on a CentOS 5.10 system

This repository contains a proof of concept for installing an Oracle RAC cluster with Puppet.  We use Vagrant to show you how to do it. Based on the information in this repo, you should be able to use the [`ora_rac`](https://github.com/hajee/ora_rac) puppet module to build your own RAC environment.

#Get started
To get started, you need the following stuff:
- Vagrant 1.6 installed and running. (** Version 1.7 of Vagrant doesn't seem to do the job**)
- A Vagrant image for CentOS 5.10 with Puppet 3.6 or higher installed. 
- The software installation files for Oracle 12.1.0.1.0
- The software installation files for Oracle Grid 12.1.0.1.0
- The packages for oracleasm
- The Puppet modules

##Vagrant installed and running
You can get vagrant from the [vagrant web site](https://www.vagrantup.com/). Remember, use version 1.6

##Vagrant image
The puppet classes and manifests in this repository are  tested on a CentOS 5.10 box with Puppet.  To be sure, you don't run into box differences; we have put up [our box on the vagrantcloud](https://vagrantcloud.com/hajee/boxes/centos-5.10-x86_64). It is not a very special box. It's just a box with Puppet V3.6 installed. So if you want to try it on another box, you can, just be sure you have Puppet installed. **To get the box running, you need at least version 3.6 of puppet**. 

##The Oracle 12.1.0.1.0 installation files
 The Oracle zip files are not part of this repository. You **MUST** provide them yourself. You can find them at [the Oracle download web site](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html). This Vagrant box uses the following zip files:
 - linuxamd64_12c_database_1of2.zip
 - linuxamd64_12c_database_2of2.zip

To get started, you need to create a folder software and put those zip's and there.

##The Grid 12.1.0.1.0 installation files
 The Grid zip files are not part of this repository. You **MUST** provide them yourself. You can find them at [the Oracle download web site](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html). This Vagrant box uses the following zip files:
 - linuxamd64_12c_grid_1of2.zip
 - linuxamd64_12c_grid_2of2.zip

To get started, you need to create a folder software and put those zip's and there.

##The packages for oracleasm
Like the Oracle installer zip files, you need to download these files yourself. You can find them at [the Oracle download page](http://www.oracle.com/technetwork/server-storage/linux/downloads/rhel5-084877.html)


For ASM, you need to download:
- [oracleasm-2.6.18-371.el5-2.0.5-1.el5.x86_64.rpm](http://oss.oracle.com/projects/oracleasm/dist/files/RPMS/rhel5/amd64/2.0.5/2.6.18-371.el5/oracleasm-2.6.18-371.el5-2.0.5-1.el5.x86_64.rpm)
- [oracleasm-support-2.1.8-1.el5.x86_64.rpm](http://oss.oracle.com/projects/oracleasm-support/dist/files/RPMS/rhel5/amd64/2.1.8/oracleasm-support-2.1.8-1.el5.x86_64.rpm)
- [oracleasmlib-2.0.4-1.el5.x86_64.rpm](http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.4-1.el5.x86_64.rpm)

You need to put those rpm's into the software folder too.

**WATCH IT** If you want to run it on a different kernel, you need other RPM's


##The packages for oracleasm

The installed add's the public Oracle repo to your system. This means it can load *most*  of the required packges. You still need to download the `oracleasmlib-2.0.4-1.el6.x86_64.rpm` file.

Like the Oracle installer zip files, you need to download these files yourself. You can find them at [Oracle ASMLib Downloads for Oracle Linux 5](http://www.oracle.com/technetwork/server-storage/linux/asmlib/ol5-1709075.html)

For ASM, you need to download:

- [oracleasmlib-2.0.4-1.el5.x86_64.rpm](http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.4-1.el5.x86_64.rpm)

You need to put this rpm into the software folder too.

##The Puppet modules

The installation of RAC is based on the excellent modules from Edwin Biemond. You can find them at [github](https://github.com/biemond/biemond-oradb). To make installation easier, we have automated the installation of all Puppet modules, by providing a `Puppetfile`. To install all modules, use:

```
$ bundle exec rake install_modules
```

This will download the latest released version of the required modules and put them at the right spot. If `rake` doesn't work and you don't know what it is, check [the description of the tools you neeed](#the-tools-to-get-it-working)


#Run the virtual machines

The Oracle RAC installation includes two Vagrant virtual machines and shared SCSI storage. To get this all running, you need to do stuff in a specific order. To make it easy for you, we have provided rake tasks to do all the work for you. To get the whole shebang up and running, use:

```
$ bundle exec rake db; bundle exec rake up; bundle exec rake provision
```

Then.......get some coffee or do some other stuff, because this takes a loooong time.


##rake db
This rake task, creates the shared disks needed for the RAC installation. It creates's both machines and connects the disks to both machines. After these tasks, all machines are shutdown.

#rake up
This rake task starts both machines but doesn't start the provisioning. This is a required because, during the deployment of the database master, the others servers need te be available at IP-level.

##rake provision
This rake tasks, run's the Puppet manifests. First on node `db1`, then on node `db2`. Node `db1` is the database master and node `db2` is a database server. The database server is placed into a running single node RAC cluster (e.g. `db1`)

#Configure your own stuff
Most configuration is done in file `puppet\hieradata\instances\example.yaml`
```yaml
ora_rac::params::db_name:            EXAMPLE
ora_rac::params::db_machines:
  db1:
    ip:    172.16.10.20
    priv:  172.17.10.20
    vip:   172.16.10.21
  db2:
    ip:    172.16.10.30
    priv:  172.17.10.30
    vip:   172.16.10.31

ora_rac::params::domain_name:        example.com
ora_rac::params::scan_name:          scan
ora_rac::params::scan_adresses:
  - '172.16.10.40'
  - '172.16.10.41'
  - '172.16.10.42'
```
- To change the database name, change parameter `ora_rac::params::db_name`.
- To change the node names, change the keys of the hash in `ora_rac::params::db_machines`.
- to change the used IP addresses, change the IP addresses in the `ora_rac::params::db_machines`.
- To add an extra node, Add an extra entry to `ora_rac::params::db_machines`

#Clean up
To clean up the two machines you can use the rake task ` destroy`:

```
$ bundle exec rake destroy
```

#The Tools to get it working
Installing a RAC cluster is a complex set of operations. We have used Puppet to make it more manageable. But to make it even easier, we've used `rake`. `Rake` is a tool that is widly used in the ruby world.  Using `rake` is easy. But getting it installed, takes some effort. To get it running, you need a ruby version of 1.9 or higher. You can check this by:

````
$ ruby -v
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]
```
You also need the `bundler` tool. This tool takes care that all required ruby libraries are loaded. You can install it with:

````
$ gem install bundler
Fetching: bundler-1.7.3.gem (100%)
Successfully installed bundler-1.7.3
Parsing documentation for bundler-1.7.3
Installing ri documentation for bundler-1.7.3
Done installing documentation for bundler after 1 seconds
1 gem installed
```
 Now we can ask `bundler` to install a required ruby gems:

```
$ bundle install
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using rake 10.3.2
...
Using librarian-puppet 1.3.2
Using bundler 1.7.3
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

To be sure all commands run within the specified set of gems, you need to prepend the commands with ` bundle exec`.



