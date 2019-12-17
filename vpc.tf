# VPC
resource "aws_vpc" "kafkaVPC" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "kafkaVPC"
  }
}

# VPC Internet Gateway
resource "aws_internet_gateway" "kafkaIG" {
  vpc_id = aws_vpc.kafkaVPC.id
  tags = {
    Name = "kafkaIG"
  }
}

# Public subnet 1
resource "aws_subnet" "kafka_public_sn_01" {
  vpc_id            = aws_vpc.kafkaVPC.id
  cidr_block        = var.subnet1_cidr_block
  availability_zone = var.sunet1_availability_zone
  tags = {
    Name = "kafka_public_sn_01"
  }
}

# Routing table for public subnet 1
resource "aws_route_table" "kafka_public_sn_rt_01" {
  vpc_id = aws_vpc.kafkaVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafkaIG.id
  }
  tags = {
    Name = "kafka_public_sn_rt_01"
  }
}
# Associate the routing table to public subnet 1
resource "aws_route_table_association" "kafka_public_sn_rt_01_assn" {
  subnet_id      = aws_subnet.kafka_public_sn_01.id
  route_table_id = aws_route_table.kafka_public_sn_rt_01.id
}

# Public subnet 2
resource "aws_subnet" "kafka_public_sn_02" {
  vpc_id            = aws_vpc.kafkaVPC.id
  cidr_block        = var.subnet2_cidr_block
  availability_zone = var.sunet2_availability_zone
  tags = {
    Name = "kafka_public_sn_02"
  }
}
# Routing table for public subnet 2
resource "aws_route_table" "kafka_public_sn_rt_02" {
  vpc_id = aws_vpc.kafkaVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafkaIG.id
  }
  tags = {
    Name = "kafka_public_sn_rt_02"
  }
}
# Associate the routing table to public subnet 2
resource "aws_route_table_association" "kafka_public_sn_rt_02_assn" {
  subnet_id      = aws_subnet.kafka_public_sn_02.id
  route_table_id = aws_route_table.kafka_public_sn_rt_02.id
}

# Public subnet 3
resource "aws_subnet" "kafka_public_sn_03" {
  vpc_id            = aws_vpc.kafkaVPC.id
  cidr_block        = var.subnet3_cidr_block
  availability_zone = var.sunet3_availability_zone
  tags = {
    Name = "kafka_public_sn_03"
  }
}
# Routing table for public subnet 3
resource "aws_route_table" "kafka_public_sn_rt_03" {
  vpc_id = aws_vpc.kafkaVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafkaIG.id
  }
  tags = {
    Name = "kafka_public_sn_rt_03"
  }
}
# Associate the routing table to public subnet 3
resource "aws_route_table_association" "kafka_public_sn_rt_03_assn" {
  subnet_id      = aws_subnet.kafka_public_sn_03.id
  route_table_id = aws_route_table.kafka_public_sn_rt_03.id
}

#  Instance Security group
resource "aws_security_group" "kafka_public_sg" {
  name   = "kafka_public_sg"
  vpc_id = aws_vpc.kafkaVPC.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 2181
    to_port   = 2181
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 9092
    to_port   = 9092
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    var.subnet1_cidr_block, var.subnet2_cidr_block, var.subnet3_cidr_block]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name = "kafka_public_sg"
  }
}