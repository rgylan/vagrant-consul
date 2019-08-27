# -*- mode: ruby -*-
# vi: set ft=ruby :

#$script = <<SCRIPT
#echo "Installing dependencies ..."
#sudo apt-get update
#sudo apt-get install -y unzip curl jq dnsutils
#echo "Determining Consul version to install ..."
#CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
#if [ -z "$CONSUL_DEMO_VERSION" ]; then
#    CONSUL_DEMO_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
#fi
#echo "Fetching Consul version ${CONSUL_DEMO_VERSION} ..."
#cd /tmp/
#curl -s https://releases.hashicorp.com/consul/${CONSUL_DEMO_VERSION}/consul_${CONSUL_DEMO_VERSION}_linux_amd64.zip -o consul.zip
#echo "Installing Consul version ${CONSUL_DEMO_VERSION} ..."
#unzip consul.zip
#sudo chmod +x consul
#sudo mv consul /usr/bin/consul
#sudo mkdir /etc/consul.d
#sudo chmod a+w /etc/consul.d
#SCRIPT

$server_script = <<SCRIPT
echo "Running server consul..."
sudo consul agent -server -bootstrap-expect=1 -data-dir=/tmp/consul -node=agent-server -bind=172.42.42.101 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
sudo consul join 172.42.42.102
SCRIPT

$client_script = <<SCRIPT
echo "Running client consul..."
sudo consul agent -ui -data-dir=/tmp/consul -node=agent-client1 -bind=172.42.42.102 -client=172.42.42.102 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
SCRIPT

# Specify a Consul version
CONSUL_DEMO_VERSION = ENV['CONSUL_DEMO_VERSION']

# Specify a custom Vagrant box for the demo
DEMO_BOX_NAME = ENV['DEMO_BOX_NAME'] || "debian/stretch64"

# Vagrantfile API/syntax version.
# NB: Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

NodeCount = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = DEMO_BOX_NAME

  config.vm.provision "shell", path: "bootstrap.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
  #config.vm.hostname = "n1"
  #config.vm.network "private_network", ip: "172.20.20.10"

  #config.vm.provision "shell",
                          #inline: $script,
                          #env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}

  #(1..NodeCount).each do |i|
  #  config.vm.define "cnode#{i}" do |workernode|
  #    workernode.vm.hostname = "agent-node#{i}"
  #    workernode.vm.network "private_network", ip: "172.20.20.1#{i}"
  #  end
    #workernode.vm.provision "shell", path: "bootstrap_kworker.sh"    
  #end

  config.vm.define "client" do |client|
    client.vm.hostname = "client-node"
    client.vm.network "private_network", ip: "172.42.42.102"
    client.vm.provision "shell", inline: $client_script, env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "server-node"
    server.vm.network "private_network", ip: "172.42.42.101"
    server.vm.provision "shell", path: "bootstrap_server.sh", env: {'CONSUL_DEMO_VERSION' => CONSUL_DEMO_VERSION}
  end

end