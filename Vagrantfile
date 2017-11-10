
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "swt2-ruby24"
  config.vm.box_url = "https://owncloud.hpi.de/index.php/s/ZLvPorv5ZA162aM/download"
  # config.vm.box_url = "https://github.com/hpi-swt2/swt2-vagrant/releases/download/v0.3/swt2-ruby24.box"

  # Try to use the following settings for better performance, disable if problems occur
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
  end

  # port forward
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.synced_folder ".", "/home/vagrant/hpi-swt2"

  # Requirements for installing gems
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y libpq-dev
    sudo apt-get install -y libsqlite3-dev
    sudo apt-get install -y g++
    exit
  SHELL

end
