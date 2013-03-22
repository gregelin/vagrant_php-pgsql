# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  
  #
  # Configure app VM - Apache2, PHP5
  #
  config.vm.define :app do |app_config|
    # Comment out gui line to run headless
    app_config.vm.boot_mode = :gui
    app_config.vm.box = "centos-6.3-nrel"
    app_config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.3-x86_64-v20130101.box"
    app_config.vm.network :hostonly, "192.168.4.11"
    app_config.vm.forward_port 80, 8080
       
    app_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "envs/v1/chef/cookbooks"
      chef.roles_path = "envs/v1/chef/roles"
      chef.add_role "base"
      chef.add_recipe "app_apache2"
      chef.add_recipe "php"
    end
  end

  #
  # Configure db VM - PostgreSQL
  #
  config.vm.define :db do |db_config|
    # Comment out gui line to run headless
    db_config.vm.boot_mode = :gui
    db_config.vm.box = "centos-6.3-nrel"
    # Uncomment box_url ONLY IF not configuring app VM first AND centos-6.3-nrel not installed locally
    # db_config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.3-x86_64-v20130101.box"
    db_config.vm.network :hostonly, "192.168.4.10"
    db_config.vm.forward_port 3306, 3306

    db_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "envs/v1/chef/cookbooks"
      chef.roles_path = "envs/v1/chef/roles"
      #  chef.data_bags_path = "envs/v1/chef/data_bags"
      chef.add_role "base"
      chef.add_recipe "postgresql_db"
      
      #
      # You may also specify custom JSON attributes:
      chef.json = {
        :postgresql => {
          :password => { :postgres => "mypassword" }
          # login to psql at vagrant CLI: psql --username=postgres -h localhost
          # enter secret3 at password prompt.
        }
      }
    end
  end

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "centos-6.3-nrel"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.3-x86_64-v20130101.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  # config.vm.forward_port 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"
  
  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding 
  # some recipes and/or roles.
  #

end
