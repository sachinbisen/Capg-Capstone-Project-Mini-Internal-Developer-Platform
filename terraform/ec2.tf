# Provision an EC2 instance that automatically runs the Dockerized application.
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  # User data bootstraps Docker and deploys the latest application image.
  user_data = <<-EOF
              #!/bin/bash
              set -ex

              # Update package metadata and install Docker engine.
              dnf update -y || yum update -y
              dnf install -y docker || yum install -y docker

              # Enable and start Docker service.
              systemctl enable docker
              systemctl start docker

              # Pull and run the application container.
              docker rm -f mini-idp-app || true
              docker pull ${var.docker_image}
              docker run -d --name mini-idp-app -p 80:3000 --restart unless-stopped ${var.docker_image}
              EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-app-server"
  })
}
