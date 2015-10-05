variable "access_key" {}
variable "secret_key" {}
variable "key_path" {}
variable "key_name" {}
variable "region" { default = "us-west-1" }
variable "availability_zone" { default = "us-west-1a" }
variable "vpc_cidr" { default = "10.128.0.0/16" }
variable "public_subnet_cidr" { default = "10.128.0.0/24" }
variable "private_subnet_cidr" { default = "10.128.1.0/24" }
variable "source_ami" { default = "ami-6bcfc42e" }
variable "datacenter" { default = "dc" }
variable "long_name" { default = "microservice-infrastructure" }
variable "ssh_username" { default = "centos" }
variable "control_count" { default = "3" }
variable "control_type" { default = "t2.small" }
variable "worker_count" { default = "3" }
variable "worker_type" { default = "t2.small" }