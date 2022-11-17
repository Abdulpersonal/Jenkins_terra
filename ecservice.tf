terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "example" {
  name = "my-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name
  capacity_providers = ["FARGATE"]
}


resource "aws_ecs_task_definition" "hello_world" {
  family                   = "terraformtaskplan"
  network_mode             = "awsvpc"
  task_role_arn = "arn:aws:iam::936519216253:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::936519216253:role/ecsTaskExecutionRole"
  container_definitions = <<DEFINITION
[
  {
    "image": "936519216253.dkr.ecr.us-east-1.amazonaws.com/pythongamingproject:updated",
    "name": "terraformtaskplan",
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 8000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "hello_world" {
  name            = "Testtask"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    security_groups = ["sg-058b62fb1ee0495ed"]
    subnets         = ["subnet-065e7dd9f48aadde1"]
    assign_public_ip = true
    
  }

}
