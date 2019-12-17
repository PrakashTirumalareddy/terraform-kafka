
resource "aws_instance" "kafka-instance-kafka-1" {
  ami                         = var.ec2_kafka_AMI
  instance_type               = var.ec2_kafka_instance_type
  key_name                    = var.ec2_kafka_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_01.id
  user_data_base64            = base64encode(local.userdata_kafka1)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_kafka1_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-kafka-1"
    cluster = "kafka"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }
}

resource "aws_instance" "kafka-instance-kafka-2" {
  ami                         = var.ec2_kafka_AMI
  instance_type               = var.ec2_kafka_instance_type
  key_name                    = var.ec2_kafka_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_02.id
  user_data_base64            = base64encode(local.userdata_kafka2)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_kafka2_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-kafka-2"
    cluster = "kafka"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }
}

resource "aws_instance" "kafka-instance-kafka-3" {
  ami                         = var.ec2_kafka_AMI
  instance_type               = var.ec2_kafka_instance_type
  key_name                    = var.ec2_kafka_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_03.id
  user_data_base64            = base64encode(local.userdata_kafka3)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_kafka3_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-kafka-3"
    cluster = "kafka"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "20"
  }
}


