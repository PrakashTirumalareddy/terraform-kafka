
resource "aws_instance" "kafka-instance-zookeeper-1" {
  ami                         = var.ec2_zookeeper_AMI
  instance_type               = var.ec2_zookeeper_instance_type
  key_name                    = var.ec2_zookeeper_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_01.id
  user_data_base64            = base64encode(local.userdata_zookeeper1)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_zookeeper1_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-zookeeper-1"
    cluster = "zookeeper"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "20"
  }
}

resource "aws_instance" "kafka-instance-zookeeper-2" {
  ami                         = var.ec2_zookeeper_AMI
  instance_type               = var.ec2_zookeeper_instance_type
  key_name                    = var.ec2_zookeeper_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_02.id
  user_data_base64            = base64encode(local.userdata_zookeeper2)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_zookeeper2_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-zookeeper-2"
    cluster = "zookeeper"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "20"
  }
}



resource "aws_instance" "kafka-instance-zookeeper-3" {
  ami                         = var.ec2_zookeeper_AMI
  instance_type               = var.ec2_zookeeper_instance_type
  key_name                    = var.ec2_zookeeper_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_03.id
  user_data_base64            = base64encode(local.userdata_zookeeper3)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_zookeeper3_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-zookeeper-3"
    cluster = "zookeeper"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "20"
  }
}
