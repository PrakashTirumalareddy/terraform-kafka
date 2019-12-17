locals {
  userdata_kafka = <<USERDATA
#!/bin/bash
set -o xtrace
sudo apt-get -qq update -y 
sudo apt-get -qq install -y openjdk-8-jdk
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
sudo sysctl -w vm.swappiness=1
echo 'vm.swappiness=1' >> /etc/sysctl.conf
sudo cat >> /etc/hosts <<EOF
${var.ec2_zookeeper1_private_ip} zookeeper1
${var.ec2_zookeeper2_private_ip}  zookeeper2
${var.ec2_zookeeper3_private_ip}  zookeeper3
${var.ec2_kafka1_private_ip} kafka1
${var.ec2_kafka2_private_ip}  kafka2
${var.ec2_kafka3_private_ip}  kafka3
EOF
sudo apt-get -qq update -y 
sudo apt-get -qq install -y xfsprogs
sudo fdisk /dev/xvdh
sudo mkfs.xfs -f /dev/xvdh
sudo mkdir -p /data/kafka
mount -t xfs /dev/xvdh /data/kafka
sudo cat >> /etc/fstab <<EOF
/dev/xvdh /data/kafka xfs defaults 0 0
EOF
chown -R ubuntu:ubuntu /data/kafka
sudo cat >> /etc/security/limits.conf <<EOF
* hard nofile 100000
* soft nofile 100000
EOF
sudo useradd kafka -m
sudo usermod -aG sudo kafka
sudo chown -R kafka:kafka /data/kafka
sudo wget -q http://www-us.apache.org/dist/kafka/2.2.1/kafka_2.12-2.2.1.tgz
sudo tar -xzf kafka_2.12-2.2.1.tgz
sudo mv kafka_2.12-2.2.1 kafka
sudo mv kafka /opt
sudo chown -R kafka:kafka /opt/kafka
sudo cat > /etc/systemd/system/kafka.service <<EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /opt/kafka/kafka.log 2>&1'
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable kafka
USERDATA

  userdata_kafka1_config = <<USERDATA
sudo cat > /opt/kafka/config/server.properties <<EOF
broker.id=1
advertised.listeners=PLAINTEXT://kafka1:9092
delete.topic.enable=true
log.dirs=/data/kafka
num.partitions=8
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
zookeeper.connection.timeout.ms=6000
auto.create.topics.enable=true
EOF
sudo systemctl start kafka
USERDATA

  userdata_kafka2_config = <<USERDATA
sudo cat > /opt/kafka/config/server.properties <<EOF
broker.id=2
advertised.listeners=PLAINTEXT://kafka2:9092
delete.topic.enable=true
log.dirs=/data/kafka
num.partitions=8
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
zookeeper.connection.timeout.ms=6000
auto.create.topics.enable=true
EOF
sudo systemctl start kafka
USERDATA

  userdata_kafka3_config = <<USERDATA
sudo cat > /opt/kafka/config/server.properties <<EOF
broker.id=3
advertised.listeners=PLAINTEXT://kafka3:9092
delete.topic.enable=true
log.dirs=/data/kafka
num.partitions=8
default.replication.factor=3
min.insync.replicas=2
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
zookeeper.connection.timeout.ms=6000
auto.create.topics.enable=true
EOF
sudo systemctl start kafka
USERDATA

  userdata_kafka1 = join("\n", [
    local.userdata_kafka,
    local.userdata_kafka1_config
  ])
  userdata_kafka2 = join("\n", [
    local.userdata_kafka,
    local.userdata_kafka2_config
  ])
  userdata_kafka3 = join("\n", [
    local.userdata_kafka,
    local.userdata_kafka3_config
  ])

}