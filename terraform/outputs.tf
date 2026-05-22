# Public IP address of the deployed EC2 application host.
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}
# Application URL served directly from EC2 host on port 3000.
output "application_url" {
  description = "Application URL for the Dockerized service running on EC2."
  value       = "http://${aws_instance.app_server.public_ip}:3000"
}

# CPU alarm name for quick navigation in CloudWatch.
output "cpu_alarm_name" {
  description = "CloudWatch alarm name for high CPU usage."
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}
