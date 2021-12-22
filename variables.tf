variable "db" {
  default = "mydatabase"
}

variable "db_user" {
  default = "postgres"
}

variable "db_pass" {
  #default = ""
}

variable "ecs_cluster_name" {
  default = "project"
}

variable "key" {
  default = "my-key"
}

variable "vpc" {
  default = "vpc-d4f5aabc"
}

variable "vpc_subnet" {
  default = "subnet-d2c7aaa8"
}

variable "region" {
  default = "eu-west-2"
}

variable "engine" {
  default = "postgres"
}

variable "engine_ver" {
  default = "9.6.20"
}

variable "instance_image" {
  default = "ami-007ef488b3574da6b"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_sub_cidr" {
  default = "172.31.16.0/20"  
}