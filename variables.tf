variable "access_key" {}
variable "secret_key" {}
#variable "key_path" {}
variable "ssh_key_name" {}
variable "ssh_key" {}
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

variable "control_type" { default = "t2.micro" }
variable "worker_count" { default = "5" }
variable "worker_type" { default = "t2.micro" }

variable "control_type" { default = "t2.small" }
variable "worker_count" { default = "3" }
variable "worker_type" { default = "t2.small" }

variable "identifier" { default = "mydb-rds"}
variable "storage" { default = "10" }
variable "engine" { default = "oracle-se"}
variable "engine_version" { default = { oracle-se = "12.1.0.1.v2"} }
variable "instance_class" { default = "db.t2.micro"}
variable "db_name" { default = "AWS_Oracle" }
variable "db_username" {}
variable "db_password" {}
variable "db_count" { default = "1"}

