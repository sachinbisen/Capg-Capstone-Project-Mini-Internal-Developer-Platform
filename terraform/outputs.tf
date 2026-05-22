# Public IP address of the deployed EC2 application host.
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.app_server.public_ip
}

# Public DNS name of the deployed EC2 application host.
output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance."
  value       = aws_instance.app_server.public_dns
}

# Easy-to-use HTTP URL for application verification.
output "application_url" {
  description = "HTTP URL to access the deployed application."
  value       = "http://${aws_instance.app_server.public_dns}"
}

# CPU alarm name for quick navigation in CloudWatch.
output "cpu_alarm_name" {
  description = "CloudWatch alarm name for high CPU usage."
  value       = aws_cloudwatch_metric_alarm.ec2_cpu_high.alarm_name
}
