provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "worker1" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 (update per region)
  instance_type = "t2.medium"
  key_name      = var.key_name

  tags = {
    Name = "Worker1-Jenkins"
  }
}

resource "aws_instance" "worker2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  key_name      = var.key_name

  tags = {
    Name = "Worker2-K8s-Worker"
  }
}

resource "aws_instance" "worker3" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  key_name      = var.key_name

  tags = {
    Name = "Worker3-K8s-Master"
  }
}

resource "aws_instance" "worker4" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  key_name      = var.key_name

  tags = {
    Name = "Worker4-K8s-Worker"
  }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-capstone-sg"
  description = "Allow necessary ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30008
    to_port     = 30008
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