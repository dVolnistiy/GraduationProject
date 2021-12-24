terraform {
  required_version = ">=0.15.0" 
}

provider "aws" {
  region = var.region
}

data "external" "script" {
  program = ["bash", "${path.cwd}/get_ip.sh"]
}

resource "aws_security_group" "terraform_group" {
  name  =  "terraform group"
  description = "Allow postgres and ssh ports"
  vpc_id = var.vpc
  
  ingress {
    description = "Port for database"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["${data.external.script.result.ip}/32",
                    "${var.vpc_sub_cidr}"]
  }

  ingress {
    description = "Port for EC2, for possible debug"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${data.external.script.result.ip}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_db_instance" "mydatabase" {
  allocated_storage      = 10
  identifier             = var.db
  engine                 = var.engine
  engine_version         = var.engine_ver
  instance_class         = "db.${var.instance_type}"
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.terraform_group.id]
  name                   = var.db
  username               = var.db_user
  password               = var.db_pass
  publicly_accessible    = true
  skip_final_snapshot    = true

  provisioner "local-exec" {
    command = "ansible-playbook role_for_rds.yaml --vault-password-file vault_pass.txt --extra-vars endpoint=${aws_db_instance.mydatabase.address}"
  }
}

resource "aws_ecs_cluster" "project" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "user-registration" {
  family                = "app"
  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "image": "dvolnistiy/postgres-user-registration:latest",
    "memory": 256,
    "name": "app"
  }
]
DEFINITION
}

data "template_file" "startup_script" {
  template = file("${path.cwd}/user_data.sh")
  vars = {
    ecs_cluster_name = var.ecs_cluster_name
  }
}

resource "aws_instance" "application" {
  ami                    = var.instance_image
  instance_type          = var.instance_type
  iam_instance_profile   = "EC2_to_ECS"
  key_name               = var.key
  subnet_id              = var.vpc_subnet
  vpc_security_group_ids = [aws_security_group.terraform_group.id]
  user_data = data.template_file.startup_script.rendered

  # if apllication start works before db is deployed
  # then it works will be a complete waste of time

  depends_on = [
    aws_db_instance.mydatabase,
  ]

  provisioner "local-exec" {
    command = "ansible-playbook role_for_ecs.yaml --vault-password-file vault_pass.txt"
  }
}
