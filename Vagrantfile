# -*- mode: ruby -*-

Vagrant.require_version ">= 1.8.3"

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: '192.168.33.22'
  config.ssh.forward_agent = true
  config.vm.define "datoca" do |datoca|
  end
  config.vm.synced_folder '.', '/vagrant', nfs: true
  config.vm.provider 'virtualbox' do |v|

    v.name = "datoca"

    host = RbConfig::CONFIG['host_os']
    # 1/4 memory and all the cores
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # Windows ¯\_(ツ)_/¯
      cpus = 2
      mem = 1024
    end
    v.customize ['modifyvm', :id, '--memory', mem]
    v.customize ['modifyvm', :id, '--cpus', cpus]
  end
  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
end
