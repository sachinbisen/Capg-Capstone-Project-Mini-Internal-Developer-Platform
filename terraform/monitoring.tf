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

# CloudWatch alarm for EC2 status checks.
# StatusCheckFailed > 0 indicates either instance-level or system-level health check failed.
resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {
  alarm_name          = "${var.project_name}-ec2-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Triggers when EC2 status checks fail, indicating instance health issues."
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.app_server.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-status-check-failed-alarm"
  })
}

# CloudWatch dashboard provides a beginner-friendly visual view of EC2 runtime health.
# Widgets include CPU, NetworkIn, NetworkOut, and status check metrics for app_server.
resource "aws_cloudwatch_dashboard" "mini_idp_dashboard" {
  dashboard_name = "mini-idp-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "EC2 CPU Utilization"
          region  = var.aws_region
          stat    = "Average"
          period  = 300
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.app_server.id]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "EC2 Network In"
          region  = var.aws_region
          stat    = "Sum"
          period  = 300
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", aws_instance.app_server.id]
          ]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "EC2 Network Out"
          region  = var.aws_region
          stat    = "Sum"
          period  = 300
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/EC2", "NetworkOut", "InstanceId", aws_instance.app_server.id]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          title   = "EC2 Status Check"
          region  = var.aws_region
          stat    = "Maximum"
          period  = 60
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.app_server.id]
          ]
          yAxis = {
            left = {
              min = 0
              max = 1
            }
          }
        }
      }
    ]
  })
}
