# Provision EC2 host for Dockerized application deployment.
# This is intentionally a Free Tier-friendly shape (default t2.micro).
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu_free_tier.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_pair_name != "" ? var.key_pair_name : null
  monitoring                  = true
  user_data_replace_on_change = true

  # User data bootstraps Ubuntu instance:
  # 1) installs Docker
  # 2) enables and starts Docker service
  # 3) pulls Docker image from Docker Hub
  # 4) runs app container on port 3000 with automatic restart policy
  user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail

              # Update package index and install Docker engine.
              apt-get update -y
              apt-get install -y docker.io

              # Enable Docker service on boot and start now.
              systemctl enable docker
              systemctl start docker
              # Pull the requested Docker image from Docker Hub.
              docker pull ${var.docker_image}

              # Replace old container if it already exists.
              docker rm -f mini-idp-app || true

              # Run application container on port 3000 and restart automatically.
              docker run -d --name mini-idp-app -p 3000:3000 --restart unless-stopped ${var.docker_image}
              EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-app-server"
    Role = "application-host"
  })
}
