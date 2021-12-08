terraform {
  required_version = ">=0.15.0" 
}

provider "aws" {}

resource "aws_db_instance" "mydatabase" {
  allocated_storage      = 10
  identifier             = var.db
  engine                 = "postgres"
  instance_class         = "db.t2.micro"
  port                   = 5432
  vpc_security_group_ids = ["sg-0bad191055634fbfa"]
  name                   = var.db
  username               = var.db_user
  password               = var.db_pass
  publicly_accessible    = true
  skip_final_snapshot    = true

  provisioner "local-exec" {
    command = "ansible-playbook role_for_rds.yaml --ask-vault-pass --key-file my-key.pem --extra-vars endpoint=${aws_db_instance.mydatabase.address}"
  }
}

resource "aws_ecs_cluster" "project" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "user-registration" {
  family = "app"
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
  
resource "aws_instance" "application" {
  ami           = "ami-007ef488b3574da6b"
  instance_type = "t2.micro"
  iam_instance_profile = "EC2_to_ECS"
  key_name = var.key
  subnet_id = var.vpc
  vpc_security_group_ids = ["sg-0bad191055634fbfa"]
  user_data = <<-EOF
  #!/bin/bash
sudo chown -R ec2-user /etc/ecs &&
echo ECS_CLUSTER="${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
  EOF

  # if apllication start works before db is deployed
  # the it works will be a complete waste of time
  depends_on = [
    aws_db_instance.mydatabase,
  ]

  provisioner "local-exec" {
    command = "ansible-playbook role_for_ecs.yaml --ask-vault-pass --key-file my-key.pem"
  }
}


