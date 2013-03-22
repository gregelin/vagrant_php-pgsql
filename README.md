READ ME
=======

# About
Vagrant_php-pgsql is a vagrant-based virtual stack providing running two virtual machines: an Apache2 web server with PHP5 installed and a separate PostgreSQL server. 

# Purpose
The purpose of this repository is to demonstrate the ability of vagrant to create a development environment that models production, including an environment consisting of multiple machines.

This repository can also be used as starter repository for building PHP projects with PostgreSQL backend. Change the recipes to build with MySQL instead.

# Worth Noting
- The PostgreSQL recipes include creating a very simple `sampledb` with `sample` schema owned by `sample_user`. This demonstrates how cookbooks can be used to pre-load database as part of the automated build process.
- The Opscode `apache2` and `postgresql` cookbooks are "wrapped" with `apache2_app` and `postgresql_db` cookbooks. The idea is to keep project specific configuration and recipe settings in the wrapper cookbooks and avoid changing the base cookbooks from Opscode in order to more easily synchronize upstream changes from Opscode.

# Dependencies
1. A computer onto which you can install software. (Tested on Mac, and Linux).
2. Download & Install VirtualBox
3. Download & Install Vagrant

# Install
1. Clone out vagrant_php-pgsql project git clone git@github.com:gregelin/vagrant_php-pgsql.git
2. Go into vagrant_php-pgsql directory and boot up the vm (in terminal) `cd vagrant_php-pgsql && vagrant up`
3. Be patient while vagrant downloads the CentOS base-box and configures your multi-vm environment. This will take a long time the first time because you need to download the CentOS. 
4. Get into the virtual machine (vm) via ssh vagrant ssh

# Use 
- `vagrant up` from the directory with this repository starts your vm and adds the correct configuration.

# Use `app` vm
- `vagrant up app` from the directory with this repository starts only your `app` vm and adds the correct configuration.
- `vagrant ssh app` from the directory with this repository to ssh into your Apache2 server
- `http://localhost:8080` in your host computer browser brings up the Apache-served pages from your `vagrant_php-pgsql` guest vm.
- `http://localhost:8080\util\phpinfo.php` in your host computer browser brings up the phpinfo file.

# Use `db` vm
- `vagrant ssh db` from the directory with this repository to ssh into your PostgreSQL server
- Accessing PostgreSQL from `db` vm:

	> sudo su postgres
	bash-4.1$ psql -d sampledb
	could not change directory to "/home/vagrant"
	psql (8.4.13)
	Type "help" for help.

	sampledb=# set search_path = sample, pg_catalog;
	SET
	sampledb=# \du
	                       List of roles
	      Role name       |  Attributes  |      Member of
	----------------------+--------------+---------------------
	 postgres             | Superuser    | {}
	                      : Create role
	                      : Create DB
	 sample_user          |              | {sampledb_dbo_role}
	 sampledb_dbo_role    | Cannot login | {}
	 sampledb_select_role | Cannot login | {}

	                    List of relations
	 Schema |          Name          |   Type   |    Owner
	--------+------------------------+----------+-------------
	 sample | contact                | table    | postgres
	 sample | contact_contact_id_seq | sequence | sample_user
	(2 rows)


# Who
This project was put together by Greg Elin at the FCC. 


