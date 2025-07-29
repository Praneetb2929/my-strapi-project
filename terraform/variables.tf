variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
variable "image_url" {
  description = "Docker image URI to deploy"
  type        = string
}
