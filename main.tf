# Create security group with firewall rules
resource "aws_security_group" "Test_security_group" {
  name        = var.security_group
  description = "Security group for Jenkins EC2 instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

# Fallback logic for AMI
locals {
  selected_ami = try(data.aws_ami.dev_ami.id, var.ami_id)
}

# Create AWS EC2 instance
resource "aws_instance" "TestInstance" {
  ami                    = local.selected_ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.Test_security_group.id]

  tags = {
    Name = var.tag_name
  }
}

# Create Elastic IP address
resource "aws_eip" "TestInstance" {
  instance = aws_instance.TestInstance.id
  vpc      = true

  tags = {
    Name = "my_elastic_ip"
  }
}
