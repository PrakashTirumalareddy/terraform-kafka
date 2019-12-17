variable "aws_region" {
  description = "Used AWS Region."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "Used CIDR Block Address to VPC."
  default     = "200.0.0.0/16"
}

variable "subnet1_cidr_block" {
  description = "Used CIDR Block Address to the Subnet."
  default     = "200.0.0.0/28"
}

variable "sunet1_availability_zone" {
  description = "Used availability to the Subnet."
  default     = "us-east-1a"
}


variable "subnet2_cidr_block" {
  description = "Used CIDR Block Address to the Subnet."
  default     = "200.0.16.0/28"
}

variable "sunet2_availability_zone" {
  description = "Used availability to the Subnet."
  default     = "us-east-1b"
}

variable "subnet3_cidr_block" {
  description = "Used CIDR Block Address to the Subnet."
  default     = "200.0.32.0/28"
}

variable "sunet3_availability_zone" {
  description = "Used availability to the Subnet."
  default     = "us-east-1c"
}

variable "ec2_zookeeper1_private_ip" {
  description = "Ip of the zookeeper node 1"
  default     = "200.0.0.10"
}

variable "ec2_zookeeper2_private_ip" {
  description = "Ip of the zookeeper node 2"
  default     = "200.0.16.10"
}

variable "ec2_zookeeper3_private_ip" {
  description = "Ip of the zookeeper node 3"
  default     = "200.0.32.10"
}

variable "ec2_zookeeper_AMI" {
  description = "AMI used for zookeepers Instances"
  default     = "ami-04b9e92b5572fa0d1"
}

variable "ec2_zookeeper_instance_type" {
  description = "Instance type for zookeepers Instances"
  default     = "t2.small"
}

variable "ec2_zookeeper_key_name" {
  description = "Key Pair name for zookeepers Instances"
  default     = "cratedb-key"
}

variable "ec2_monitoring_private_ip" {
  description = "Ip of the monitoring node 1"
  default     = "200.0.0.12"
}


variable "ec2_monitoring_AMI" {
  description = "AMI used for monitoring Instances"
  default     = "ami-04b9e92b5572fa0d1"
}

variable "ec2_monitoring_instance_type" {
  description = "Instance type for monitoring Instances"
  default     = "t2.micro"
}

variable "ec2_monitoring_key_name" {
  description = "Key Pair name for monitoring Instances"
  default     = "cratedb-key"
}

variable "ec2_kafka1_private_ip" {
  description = "Ip of the kafka node 1"
  default     = "200.0.0.9"
}

variable "ec2_kafka2_private_ip" {
  description = "Ip of the kafka node 2"
  default     = "200.0.16.9"
}

variable "ec2_kafka3_private_ip" {
  description = "Ip of the kafka node 3"
  default     = "200.0.32.9"
}

variable "ec2_kafka_AMI" {
  description = "AMI used for kafkas Instances"
  default     = "ami-04b9e92b5572fa0d1"
}

variable "ec2_kafka_instance_type" {
  description = "Instance type for kafkas Instances"
  default     = "t2.small"
}

variable "ec2_kafka_key_name" {
  description = "Key Pair name for kafkas Instances"
  default     = "cratedb-key"
}