provider "aws" {
  region = var.aws_region
}

# Create security group with firewall rules
resource "aws_security_group" "my_security_group" {
  name        = var.security_group
  description = "security group for EC2 instance"

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

  # Outbound from Jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

# Create AWS EC2 instance
resource "aws_instance" "myFirstInstance" {
  ami           = "ami-0ad21ae1d0696ad58"   # AMI IDs must be in quotes
  key_name      = "terraform"              # Key names must be in quotes
  instance_type = "t2.micro"               # Instance types must be in quotes

  vpc_security_group_ids = [sg-000f2df64cc6be8b8]  # Reference security group by ID

  tags = {
    Name = "myFirstInstance"  # Tags must be in quotes
  }
}

# Create Elastic IP address
resource "aws_ip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id

  tags = {
    Name = "my_ip"
  }
}
