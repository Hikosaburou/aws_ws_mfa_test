data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"]
}

data "aws_ami" "winsv_2019" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["801119661308"]
}


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.winsv_2019.id
  instance_type               = "t3.small"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_a.id
  key_name                    = var.key_name

  tags = {
    Name  = "${var.prefix}-${var.account}-bastion"
    owner = var.prefix
  }
}

resource "aws_instance" "radius" {
  ami                         = data.aws_ami.amazonlinux2.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_a.id
  key_name                    = var.key_name

  tags = {
    Name  = "${var.prefix}-${var.account}-radius"
    owner = var.prefix
  }
}
