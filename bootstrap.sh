#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.101 consul.server.com consulsvr
172.42.42.102 client1.example.com client1
172.42.42.103 consul.services.com consulsvc
EOF

# Installing dependencies ...
echo "[TASK 2] Installing dependencies ..."
sudo apt-get update
sudo apt-get install -y unzip curl jq dnsutils

# Determining Consul version to install ...
echo "[TASK 3] Determining Consul version to install ..."
CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"
if [ -z "$CONSUL_DEMO_VERSION" ]; then
    CONSUL_DEMO_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

# Fetching Consul version
echo "[TASK 4] Fetching Consul version ${CONSUL_DEMO_VERSION} ..."
cd /tmp/
curl -s https://releases.hashicorp.com/consul/${CONSUL_DEMO_VERSION}/consul_${CONSUL_DEMO_VERSION}_linux_amd64.zip -o consul.zip

# Installing Consul version
echo "[TASK 5] Installing Consul version ${CONSUL_DEMO_VERSION} ..."
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d
sudo mkdir /var/log/consul
sudo chmod 755 /var/log/consul

#sudo consul agent -server -bootstrap-expect=1 -data-dir=/tmp/consul -node=agent-two -bind=172.20.20.10 -enable-script-checks=true -config-dir=/etc/consul.d/ &
#sudo consul agent -server -bind=172.20.20.10 -data-dir=/tmp/consul &

#cat >>/home/vagrant/run-consul <<EOF
#sudo mkdir /var/log/consul
#sudo chmod 755 /var/log/consul
#sudo consul agent -server -bind=172.20.20.10 -data-dir=/tmp/consul >> /var/log/consul/output.log &
#EOF

#chown vagrant:vagrant run-consul 
#chmod 755 /home/vagrant/run-consul
#/home/vagrant/run-consul