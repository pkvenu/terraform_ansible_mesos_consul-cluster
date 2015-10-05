resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.long_name}"
  }
}
resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_cidr}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.long_name}"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.long_name}"
  }
}
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.long_name}"
  }
}
resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_instance" "control_nodes" {
  ami = "${var.source_ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.control_type}"
  count = "${var.control_count}"
  vpc_security_group_ids = ["${aws_security_group.control.id}", "${aws_vpc.main.default_security_group_id}", "${aws_security_group.consul.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address=true
  subnet_id = "${aws_subnet.main.id}"

  connection {
    user = "${var.ssh_username}"
    key_file = "${var.key_path}"
  }

  root_block_device {
    delete_on_termination = true
  }

  tags {
    Name = "control-${format("%02d", count.index+1)}"
    sshUser = "${var.ssh_username}"
    role = "control"
    dc = "${var.datacenter}"
  }
}
resource "aws_instance" "worker_nodes" {
  ami = "${var.source_ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.worker_type}"
  count = "${var.worker_count}"
  vpc_security_group_ids = ["${aws_security_group.worker.id}", "${aws_vpc.main.default_security_group_id}", "${aws_security_group.consul.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address=true
  subnet_id = "${aws_subnet.main.id}"

  connection {
    user = "${var.ssh_username}"
    key_file = "${var.key_path}"
  }

  root_block_device {
    delete_on_termination = true
  }

  tags {
    Name = "worker-${format("%02d", count.index+1)}"
    sshUser = "${var.ssh_username}"
    role = "worker"
    dc = "${var.datacenter}"
  }
}

resource "aws_security_group" "control" {
  name = "control"
  description = "Allow inbound traffic for control nodes"
  vpc_id="${aws_vpc.main.id}"

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # Mesos
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # Marathon
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # Chronos
    from_port = 4400
    to_port = 4400
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ICMP
    from_port=-1
    to_port=-1
    protocol = "icmp"
    cidr_blocks=["0.0.0.0/0"]
  }

}
resource "aws_security_group" "worker" {
  name = "worker"
  description = "Allow inbound traffic for worker nodes"
  vpc_id="${aws_vpc.main.id}"

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # HTTP
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # HTTPS
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # Mesos
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ICMP
    from_port=-1
    to_port=-1
    protocol = "icmp"
    cidr_blocks=["0.0.0.0/0"]
  }

}
resource "aws_security_group" "consul" {
  name = "consul"
  description = "consul internal traffic + maintenance."
  vpc_id="${aws_vpc.main.id}"

  egress {
    from_port = 53
    to_port = 53
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8400
    to_port = 8400
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8600
    to_port = 8600
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8300
    to_port = 8302
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 8300
    to_port = 8302
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8400
    to_port = 8400
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8500
    to_port = 8500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 8600
    to_port = 8600
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 53
    to_port = 53
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8400
    to_port = 8400
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8600
    to_port = 8600
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8300
    to_port = 8302
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = 8300
    to_port = 8302
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8400
    to_port = 8400
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8600
    to_port = 8600
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "${file(\"ssh/insecure-deployer.pub\")}"
}