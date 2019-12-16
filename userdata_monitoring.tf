locals {
  userdata_monitoring = <<USERDATA
#!/bin/bash
set -o xtrace
sudo cat >> /etc/hosts <<EOF
${var.ec2_zookeeper1_private_ip} zookeeper1
${var.ec2_zookeeper2_private_ip}  zookeeper2
${var.ec2_zookeeper3_private_ip}  zookeeper3
EOF
sudo apt-get update  -y 
sudo apt-get -qq install -y wget ca-certificates zip net-tools vim nano tar netcat nmap-ncat
sudo apt-get -qq install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get -qq update  -y 
sudo apt-get -qq install -y docker-ce docker-ce-cli containerd.io docker-compose
sudo cat > ~/zoonavigator-docker-compose.yml <<EOF
version: '2'

services:
  # https://github.com/elkozmon/zoonavigator
  web:
    image: elkozmon/zoonavigator-web:latest
    container_name: zoonavigator-web
    network_mode: host
    environment:
      API_HOST: "localhost"
      API_PORT: 9001
      SERVER_HTTP_PORT: 8001
    depends_on:
     - api
    restart: always
  api:
    image: elkozmon/zoonavigator-api:latest
    container_name: zoonavigator-api
    network_mode: host
    environment:
      SERVER_HTTP_PORT: 9001
    restart: always

EOF
docker-compose -f ~/zoonavigator-docker-compose.yml up -d
USERDATA

}