$master_script = <<SCRIPT
#!/bin/bash

apt-get install curl -y
OS_CODENAME=$(lsb_release -sc)
OS_DISTID=$(lsb_release -si | tr '[A-Z]' '[a-z]')
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y --force-yes install oracle-j2sdk1.7
apt-get install -q -y --force-yes build-essential --no-install-recommends
apt-get install -q -y --force-yes build-essential --no-install-recommends
apt-get install -q -y --force-yes ruby1.9.1-dev --no-install-recommends
apt-get install -q -y --force-yes ruby1.9.3 --no-install-recommends
gem install cf
SCRIPT

$hosts_script = <<SCRIPT
cat > /etc/hosts <<EOF
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

EOF
SCRIPT

Vagrant.configure("2") do |config|

  # Define base image
  config.vm.box = "ubuntu-14.04-amd64-vbox"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"
  config.vm.synced_folder "#{ENV['HOME']}/vagrant-vm-cluster-mongodb3/shared/exports", "#{ENV['HOME']}/vagrant-vm-cluster-mongodb3/shared/other", :mount_options => ["dmode=777","fmode=777"]

  # Manage /etc/hosts on host and VMs
  config.hostmanager.enabled = false
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.hostmanager.ignore_private_ip = false

  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box"
  end

  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Install Docker
    pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
      "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
      "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
    # Add vagrant user to the docker group
    pkg_cmd << "usermod -a -G docker vagrant; "
    config.vm.provision :shell, :inline => pkg_cmd
  end

  config.vm.define :master do |master|
    master.vm.provider :virtualbox do |v|
      v.name = "vm-cluster-mongodb3"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    master.vm.network :private_network, ip: "10.211.55.112"
    master.vm.hostname = "vm-cluster-mongodb3"
    master.vm.provision :shell, :inline => $hosts_script
    master.vm.provision :hostmanager
    master.vm.provision :shell, :inline => $master_script
    master.vm.provision :chef_solo do |chef|
      chef.add_recipe "mongodb3-debs"
    end
  end
end
