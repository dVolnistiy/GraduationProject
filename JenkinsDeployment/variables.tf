variable "region" {
    default = "eu-west-2"
}

variable "vpc" {
  default = "vpc-d4f5aabc"
}

variable "instance_image" {
  default = "ami-0d37e07bd4ff37148"
}

variable "instance_type" {
  default = "t2.small"
}

variable "key" {
  default = "my-key"
}

variable "vpc_subnet" {
  default = "subnet-ed78cba1"
}
