resource "aws_instance" "kafka-instance-monitoring" {
  ami                         = var.ec2_monitoring_AMI
  instance_type               = var.ec2_monitoring_instance_type
  key_name                    = var.ec2_monitoring_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_01.id
  user_data_base64            = base64encode(local.userdata_monitoring)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_monitoring_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-monitoring"
    cluster = "zookeeper"
  }
  vpc_security_group_ids = [aws_security_group.kafka_monitoring_sg.id]
}

#  Instance Security group
resource "aws_security_group" "kafka_monitoring_sg" {
  name   = "kafka_monitoring_sg"
  vpc_id = aws_vpc.kafkaVPC.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 8001
    to_port   = 8001
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
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