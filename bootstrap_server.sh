#!/bin/bash

# Boot consul cluster
echo "[TASK 1] Boot consul cluster ..."
sudo chmod 755 /vagrant/boot-consul-cluster.sh
sudo /vagrant/boot-consul-cluster.sh