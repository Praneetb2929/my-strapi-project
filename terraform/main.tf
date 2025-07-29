resource "aws_ecr_repository" "strapi" {
  name = "strapi-app"
}

resource "aws_cloudwatch_log_group" "ecs_strapi" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "image_url=607700977843.dkr.ecr.us-east-1.amazonaws.com/strapi-app:1753598519"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs/strapi"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "StrapiDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [["ECS/ContainerInsights", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi.name]],
          view = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title = "CPU Utilization"
        }
      },
      {
        type = "metric",
        x = 0,
        y = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [["ECS/ContainerInsights", "MemoryUtilization", "ClusterName", aws_ecs_cluster.strapi.name]],
          view = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title = "Memory Utilization"
        }
      },
      {
        type = "metric",
        x = 0,
        y = 12,
        width = 12,
        height = 6,
        properties = {
          metrics = [["ECS/ContainerInsights", "RunningTaskCount", "ClusterName", aws_ecs_cluster.strapi.name]],
          view = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title = "Task Count"
        }
      },
      {
        type = "metric",
        x = 0,
        y = 18,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "NetworkRxBytes", "ClusterName", aws_ecs_cluster.strapi.name],
            ["ECS/ContainerInsights", "NetworkTxBytes", "ClusterName", aws_ecs_cluster.strapi.name]
          ],
          view = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title = "Network In/Out"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "ECS/ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU exceeds 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi.name
  }
}

