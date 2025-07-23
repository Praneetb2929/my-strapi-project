variable "docker_image_url" {
  description = "Docker image URL for the Strapi container"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to the ECS tasks"
  type        = string
}
