data "aws_ami" "centos" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^CentOS Linux 7"
  owners           = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "web" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web" {
  key_name   = "${var.project_name}-web"
  public_key = tls_private_key.web.public_key_openssh
}

output "private_key" {
  value = tls_private_key.web.private_key_pem
}

resource "aws_security_group" "web" {
  description = "${var.project_name} web"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "${var.project_name}"
  }
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.centos.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.web.key_name
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.web.id]

  tags = {
    Name = "${var.project_name}-private"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  vpc      = true
}
