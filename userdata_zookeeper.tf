locals {
  userdata_zookeeper = <<USERDATA
#!/bin/bash
set -o xtrace
sudo mount -a
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
sudo apt-get -qq install -y wget ca-certificates zip net-tools vim nano tar netcat nmap-ncat
sudo apt-get -qq install -y openjdk-8-jdk
sudo mkfs -t ext4 /dev/xvdh
sudo mkdir /dataz
sudo mount /dev/xvdh /dataz/
sudo mkfs -t ext4 /dev/xvdj
sudo mkdir /logs
sudo mount /dev/xvdj /logs/
sudo cat >> /etc/fstab <<EOF
/dev/xvdh       /dataz   ext4    defaults,nofail        0       0
/dev/xvdj       /logs   ext4    defaults,nofail        0       0
EOF
sudo adduser zookeeper
usermod -aG sudo zookeeper
sudo mkdir -p /dataz/zookeeper
sudo chown -R zookeeper:zookeeper /dataz
sudo mkdir -p /logs/zookeeper
sudo chown -R zookeeper:zookeeper /logs
sudo wget -q https://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
sudo tar -xzf zookeeper-3.4.9.tar.gz
sudo mv zookeeper-3.4.9 zookeeper
sudo mv zookeeper /opt
sudo chown -R zookeeper:zookeeper /opt/zookeeper
sudo cat > /opt/zookeeper/conf/zoo.cfg <<EOF
dataDir=/dataz/zookeeper
dataLogDir=/logs/zookeeper
clientPort=2181
maxClientCnxns=0
tickTime=2000
initLimit=10
syncLimit=5
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
EOF

sudo cat > /etc/systemd/system/zookeeper.service <<EOF
[Unit]
Description=Zookeeper Daemon
Documentation=http://zookeeper.apache.org
Requires=network.target
After=network.target

[Service]    
Type=forking
WorkingDirectory=/opt/zookeeper
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start /opt/zookeeper/conf/zoo.cfg
ExecStop=/opt/zookeeper/bin/zkServer.sh stop /opt/zookeeper/conf/zoo.cfg
ExecReload=/opt/zookeeper/bin/zkServer.sh restart /opt/zookeeper/conf/zoo.cfg
TimeoutSec=30
Restart=on-failure

[Install]
WantedBy=default.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable zookeeper
USERDATA


  userdata_zookeeper1 = join("\n", [
    local.userdata_zookeeper,
    "echo \"1\" > /dataz/zookeeper/myid",
    "sudo chown  zookeeper:zookeeper /dataz/zookeeper/myid ",
    "systemctl start zookeeper"
  ])
  userdata_zookeeper2 = join("\n", [
    local.userdata_zookeeper,
    "echo \"2\" > /dataz/zookeeper/myid",
    "sudo chown  zookeeper:zookeeper /dataz/zookeeper/myid ",
    "systemctl start zookeeper"
  ])
  userdata_zookeeper3 = join("\n", [
    local.userdata_zookeeper,
    "echo \"3\" > /dataz/zookeeper/myid",
    "sudo chown  zookeeper:zookeeper /dataz/zookeeper/myid ",
    "systemctl start zookeeper",
  ])

}