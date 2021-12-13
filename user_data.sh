#!/bin/bash
sudo chown -R ec2-user /etc/ecs &&
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config