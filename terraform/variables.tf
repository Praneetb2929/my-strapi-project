variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs in the VPC"
  type        = list(string)
}

variable "strapi_image_url" {
  description = "Full image URL (e.g., <account>.dkr.ecr.<region>.amazonaws.com/strapi-app:tag)"
  type        = string
}

variable "strapi_cpu" {
  description = "CPU units for the Strapi task"
  type        = string
  default     = "512"
}

variable "strapi_memory" {
  description = "Memory (in MiB) for the Strapi task"
  type        = string
  default     = "1024"
}
