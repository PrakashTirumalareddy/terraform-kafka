resource "aws_instance" "kafka-instance-monitoring" {
  ami                         = var.ec2_monitoring_AMI
  instance_type               = var.ec2_monitoring_instance_type
  key_name                    = var.ec2_monitoring_key_name
  subnet_id                   = aws_subnet.kafka_public_sn_01.id
  user_data_base64            = base64encode(local.userdata_zookeeper1)
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  private_ip                  = var.ec2_monitoring_private_ip
  associate_public_ip_address = true
  tags = {
    Name    = "terraform-monitoring"
    cluster = "zookeeper"
  }
  vpc_security_group_ids = [aws_security_group.kafka_public_sg.id]
}
