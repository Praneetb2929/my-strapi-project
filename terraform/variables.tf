variable "aws_region" {
  default = "us-east-1"
}

variable "image_url" {
  description = "URL of the Docker image in ECR"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for the ECS service"
}
