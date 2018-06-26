locals {
  key_name = "${var.ssh_public_key_name == "" ? var.cluster-name : var.ssh_public_key_name }"
  key_file = "${var.ssh_public_key_file == "" ? "keys/${var.cluster-name}.pub" : var.ssh_public_key_file }"
}

resource "aws_key_pair" "bastion-host-key" {
  key_name   = "${local.key_name}"
  public_key = "${file(local.key_file)}"
}

resource "aws_instance" "bastion" {
  ami           = "${var.ami_id}"
  instance_type = "t2.small"
  subnet_id     = "${element(aws_subnet.demo-public.*.id, count.index)}"
  count         = 1

  # key_name      = "${aws_key_pair.bastion-host-key.key_name}"
  associate_public_ip_address = true

  key_name = "${aws_key_pair.bastion-host-key.key_name}"

  tags {
    Name        = "${var.cluster-name}-bastion-host"
    Environment = "${var.cluster-name}"
  }

  vpc_security_group_ids = [
    "${aws_security_group.ssh.id}",
    "${aws_security_group.vpc-internal.id}",
  ]
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow only ssh"
  vpc_id      = "${aws_vpc.demo.id}"

  // allow traffic for TCP 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name         = "ssh"
    "Created By" = "terraform"
  }
}

resource "aws_security_group" "vpc-internal" {
  name        = "${var.cluster-name} VPC internal"
  description = "Allow all VPC internal communication"
  vpc_id      = "${aws_vpc.demo.id}"

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc-cidr-block}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.vpc-cidr-block}"]
  }

  tags {
    "Created By" = "terraform"
  }
}
