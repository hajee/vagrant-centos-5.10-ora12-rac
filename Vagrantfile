# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "db1" do |db1|

    db1.vm.box = "hajee/centos-5.10-x86_64"

    db1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

    db1.ssh.forward_agent = true
    db1.ssh.forward_x11 = true

    db1.vm.provider :virtualbox do |vb|

      # vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--name", "db1"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--nic3", "intnet"]
    end

    db1.vm.hostname = "db1.example.com"
    db1.vm.network :private_network, ip: "172.16.10.20"

    db1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

    db1.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    db1.vm.provision :shell, :inline => "rm -rf /etc/puppet/hieradata; ln -sf /vagrant/puppet/hieradata /etc/puppet/hieradata"

    db1.vm.provision :puppet do |puppet|
      puppet.module_path       = "puppet/modules"
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --parser future"
      puppet.facter = {
        'vm_type'     => 'vagrant',
      }
    end
  end

  config.vm.define "db2" do |db2|

    db2.vm.box = "hajee/centos-5.10-x86_64"

    db2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

    db2.vm.provider :virtualbox do |vb|

      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--name", "db2"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--nic3", "intnet"]
    end

    db2.vm.hostname = "db2.example.com"
    db2.vm.network :private_network, ip: "172.16.10.30"

    db2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]

    db2.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    db2.vm.provision :shell, :inline => "rm -rf /etc/puppet/hieradata; ln -sf /vagrant/puppet/hieradata /etc/puppet/hieradata"

    db2.vm.provision :puppet  do |puppet|
      puppet.module_path       = "puppet/modules"
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --parser future"
      puppet.facter = {
        'vm_type'     => 'vagrant',
      }
    end
  end

end
