resource "aws_ecs_cluster" "main" {
  name = "cluster-demo"
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacityProvider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = data.terraform_remote_state.auto-scaling.outputs.auto-scaling-arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family       = "application-nginx"
  network_mode = "awsvpc"
  #execution_role_arn = "arn:aws:iam::532199187081:role/ecsTaskExecutionRole"
  cpu = 256
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "containernginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = ["${data.terraform_remote_state.vpc.outputs.id_subnet[1]}", "${data.terraform_remote_state.vpc.outputs.id_subnet[2]}"]
    security_groups = ["${data.terraform_remote_state.vpc.outputs.id_security_ecs}"]
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = plantimestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.lb.outputs.target_group_arn
    container_name   = "containernginx"
    container_port   = 80
  }
}