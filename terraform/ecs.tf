resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "512"
  memory                  = "1024"
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn
  container_definitions   = jsonencode([
    {
      name      = "strapi"
      image     = var.docker_image_url
      essential = true
      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_CLIENT"
          value = "sqlite" # or postgres
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups  = [var.security_group_id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }
}
