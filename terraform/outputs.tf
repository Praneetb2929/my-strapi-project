output "ecr_repository_url" {
  value = aws_ecr_repository.strapi.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.strapi.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.strapi.arn
}  
