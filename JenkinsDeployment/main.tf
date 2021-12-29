terraform {
  required_version = ">0.15.0"
}

provider "aws" {
    region = var.region
}

data "external" "script" {
  program = ["bash", "../get_ip.sh"]
}

resource "aws_security_group" "GroupForJenkins" {
    name = "JenkinsGroup"
    description = "allow 22 ssh and 8080 for Jenkins"
    vpc_id = var.vpc

    ingress {
        description = "Port for Jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Port for configuring Jenkins"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${data.external.script.result.ip}/32"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "Jenkins" {
    ami           = var.instance_image
    instance_type = var.instance_type
    iam_instance_profile = "Jenkins-role-for-project"
    key_name      = var.key
    subnet_id = var.vpc_subnet
    vpc_security_group_ids = [aws_security_group.GroupForJenkins.id]

    tags = {
        Name = "Jenkins1"
    }

   provisioner "local-exec" {
       command = "sleep 10; ansible-playbook role_for_Jenkins.yaml --key-file 'my-key.pem' -b"
   }
}