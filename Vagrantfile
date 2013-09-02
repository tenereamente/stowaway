# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "opscode-ubuntu-13.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  config.vm.network :forwarded_port, guest: 80, host: 8880, auto_correct: false

  # this block of settings are specific to virtualbox,
  # ignored for other providers
  config.vm.provider :virtualbox do |vb|
    # This setting makes it so that network access from the vagrant guest is able to
    # resolve connections using the hosts VPN connection
    # it means we can DNS resolve internal.vpn domains
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # This setting gives the VM 1 GB of MEMORIES. Same size as staging machine.
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  end

  # This setting makes it so that network access from the vagrant guest is
  # able to use the SSH private keys that are present on the host without
  # copying them into the VM.
  # it means we can authenticate to internal.vpn
  config.ssh.forward_agent = true
  # We want this VM to be reachable on the private host network as well,
  # so that the other VM's that are running IE can access our dev server
  config.vm.network :private_network, ip: "192.168.50.50"

  cookbooks_path = ["chef/cookbooks", "chef/site-cookbooks"]

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = cookbooks_path
    chef.data_bags_path = "chef/data_bags"
    chef.roles_path = "chef/roles"
    chef.add_role "vagrant"
    chef.add_recipe "custom::vagrant"
  end
end
