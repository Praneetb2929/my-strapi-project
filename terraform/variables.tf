variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "strapi_image_url" {
  description = "ECR image URL for Strapi app"
  type        = string
}

variable "strapi_cpu" {
  description = "CPU units for ECS task"
  type        = number
}

variable "strapi_memory" {
  description = "Memory for ECS task"
  type        = number
}
