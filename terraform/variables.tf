variable "strapi_image_url" {
  type        = string
  description = "ECR image URL for Strapi app"
}

variable "image_tag" {
  type        = string
  description = "Git commit SHA used as Docker image tag"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for ECS service"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "strapi_cpu" {
  type        = number
  description = "CPU units for ECS task"
}

variable "strapi_memory" {
  type        = number
  description = "Memory (in MiB) for ECS task"
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}