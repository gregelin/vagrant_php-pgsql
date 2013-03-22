#
# Cookbook Name:: postgresql_db
# Recipe:: default
#
# Based on Opscode postgresql cook book (Copyright 2009, Opscode, Inc.)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Turn off CentOS firewall
#
# execute "Turn off CentOS firewall" do
#   user "root"
#   command "service iptables stop"
#   command "chkconfig iptables off"
# end

#
# Load firewall rules we know works
#
template "/etc/sysconfig/iptables" do
  # path "/etc/sysconfig/iptables"
  source "iptables.erb"
  owner "root"
  group "root"
  mode 00600
  # notifies :restart, resources(:service => "iptables")
end

execute "service iptables restart" do
  user "root"
  command "service iptables restart"
end


#
# set values postgres access
#
node.default['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
  # {:type => 'host', :db => 'all', :user => 'all', :addr => '192.168.4.11', :mask??? => '255.255.255.0', :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '192.168.4.0/24', :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]

# 
# Enable broad access from other VMs in our virtual stack
#
node.default['postgresql']['config']['listen_addresses'] = '*'
node.default['postgresql']['config']['port'] = 5432
node.default['postgresql']['config']['max_connections'] = 100

# 
# Set password for postress user#
#
node.default['postgresql']['password']['postgres'] = "mypassword"

#
# Set a fixed password for the postgresql user postgres
# It is essential to set the password when using Chef-Solo with vagrant.
# login to psql at vagrant CLI: psql --username=postgres -h localhost
# enter <password> at password prompt.
#

#
# Alternate way to configure postgresql password is in Vagrant file. 
#  config.vm.provision :chef_solo do |chef|
  # chef.json = {
  #    :postgresql => {
  #       :password => { :postgres => "mypassword" }
  #       # login to psql at vagrant CLI: psql --username=postgres -h localhost
  #       # enter secret3 at password prompt.
  #    }
  #  }
# end


include_recipe "postgresql::client"
include_recipe "postgresql::server"

#
# Update CentOS user postgres password
#
user "postgres" do
  # openssl passwd -1 "secret0"
  password "$1$PDHeijmW$uPSxzskoN6uZaPe/NIkig0"
  action :modify
end

#
# Create database using bash
#
execute "create postgresql sampledb" do
	user "postgres"
	command "createdb sampledb"
end

#
# Create run the set up scripts
#
execute "setup bpibdb schema, users, tables" do
  user "postgres"
  command "psql -d sampledb -f /vagrant/data/db_bak/sample_postgres_restore.sql"
end

#
# Testing that database has been created 
#
# new-host:php+pgsql2 gregelin$ vagrant ssh db
# Welcome to your Vagrant-built virtual machine.
# [vagrant@localhost ~]$ sudo su postgres
# bash-4.1$ psql -d sampledb
# could not change directory to "/home/vagrant"
# psql (8.4.13)
# Type "help" for help.

# sampledb=# set search_path = sample, pg_catalog;
# SET
# sampledb=# \du
#                        List of roles
#       Role name       |  Attributes  |      Member of
# ----------------------+--------------+---------------------
#  postgres             | Superuser    | {}
#                       : Create role
#                       : Create DB
#  sample_user          |              | {sampledb_dbo_role}
#  sampledb_dbo_role    | Cannot login | {}
#  sampledb_select_role | Cannot login | {}

# sampledb=# \d
#                     List of relations
#  Schema |          Name          |   Type   |    Owner
# --------+------------------------+----------+-------------
#  sample | contact                | table    | postgres
#  sample | contact_contact_id_seq | sequence | sample_user
# (2 rows)

# sampledb=# select * from sample.contact;
#  contact_id | call_sign | first_name | last_name | phone | email | website_url | time_stamp
# ------------+-----------+------------+-----------+-------+-------+-------------+------------
# (0 rows)