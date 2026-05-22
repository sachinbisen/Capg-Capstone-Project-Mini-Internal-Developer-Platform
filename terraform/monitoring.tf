# CloudWatch alarm for EC2 CPU utilization.
# This helps beginners see when compute load is consistently high.
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.project_name}-ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers when EC2 average CPU utilization stays above 70%."
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.app_server.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-high-cpu-alarm"
  })
}
