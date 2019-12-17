output "monitoring_ip" {
  value       = aws_instance.kafka-instance-monitoring.public_ip
  description = "Monitoring instance, access monitoring on port 8001"
}