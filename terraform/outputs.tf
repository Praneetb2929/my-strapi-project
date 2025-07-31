output "alb_dns" {
  value = aws_lb.strapi.dns_name
}

output "ecs_cluster" {
  value = aws_ecs_cluster.strapi.name
}
