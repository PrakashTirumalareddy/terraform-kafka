locals {
  userdata_monitoring = <<USERDATA
#!/bin/bash
set -o xtrace
sudo cat >> /etc/hosts <<EOF
${var.ec2_zookeeper1_private_ip} zookeeper1
${var.ec2_zookeeper2_private_ip}  zookeeper2
${var.ec2_zookeeper3_private_ip}  zookeeper3
${var.ec2_kafka1_private_ip} kafka1
${var.ec2_kafka2_private_ip}  kafka2
${var.ec2_kafka3_private_ip}  kafka3
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
sudo cat > ~/kafka-manager-docker-compose.yml <<EOF
version: '2'

services:
  # https://github.com/yahoo/kafka-manager
  kafka-manager:
    image: qnib/plain-kafka-manager
    network_mode: host
    environment:
      ZOOKEEPER_HOSTS: "zookeeper1:2181,zookeeper2:2181,zookeeper3:2181"
      APPLICATION_SECRET: P@ssw0rd
    restart: always
EOF
docker-compose -f ~/kafka-manager-docker-compose.yml up -d
sudo cat > ~/kafka-topics-ui-docker-compose.yml <<EOF
version: '2'

services:
  # https://github.com/confluentinc/schema-registry
  confluent-schema-registry:
    image: confluentinc/cp-schema-registry:3.2.1
    network_mode: host
    environment:
      SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL: zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
      SCHEMA_REGISTRY_LISTENERS: http://0.0.0.0:8081
      # please replace this setting by the IP of your web tools server
      SCHEMA_REGISTRY_HOST_NAME: "${aws_eip.kafka-instance-monitoring.public_ip}"
    restart: always

  # https://github.com/confluentinc/kafka-rest
  confluent-rest-proxy:
    image: confluentinc/cp-kafka-rest:3.2.1
    network_mode: host
    environment:
      KAFKA_REST_BOOTSTRAP_SERVERS: kafka1:9092,kafka2:9092,kafka3:9092
      KAFKA_REST_ZOOKEEPER_CONNECT: zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
      KAFKA_REST_LISTENERS: http://0.0.0.0:8082/
      KAFKA_REST_SCHEMA_REGISTRY_URL: http://localhost:8081/
      # please replace this setting by the IP of your web tools server
      KAFKA_REST_HOST_NAME: "${aws_eip.kafka-instance-monitoring.public_ip}"
    depends_on:
      - confluent-schema-registry
    restart: always

  # https://github.com/Landoop/kafka-topics-ui
  kafka-topics-ui:
    image: landoop/kafka-topics-ui:0.9.2
    network_mode: host
    environment:
      KAFKA_REST_PROXY_URL: http://localhost:8082
      PROXY: "TRUE"
    depends_on:
      - confluent-rest-proxy
    restart: always
EOF
docker-compose -f ~/kafka-topics-ui-docker-compose.yml up -d

USERDATA

}