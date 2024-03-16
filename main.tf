provider "aws" {
  region = "eu-west-2"  # Insert region
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "devops"  # Insert key name
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web" {
  name        = "devops-security-group" # Insert security group
  description = "Allow inbound traffic to ports 22, 80, and 443"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0d18e50ca22537278"  # Insert AMI ID
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.web.name]

  tags = {
    Name = "Test EC2 Instance"
  }
}