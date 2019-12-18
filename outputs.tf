output "monitoring_ip" {
  value       = aws_eip.kafka-instance-monitoring.public_ip
  description = "Monitoring instance, access monitoring on port 8001"
}