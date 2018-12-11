# Test env for bootstrap.sh

ENV['LC_ALL'] = 'en_US.UTF-8'

Vagrant.configure('2') do |config|
    config.vm.box = 'ubuntu/bionic64'
    config.vm.provision 'shell', inline: '/vagrant/bootstrap.sh', privileged: false
    config.ssh.forward_agent = true
    config.ssh.forward_x11 = true
    # config.vm.network "public_network"

    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 3
    end
end
