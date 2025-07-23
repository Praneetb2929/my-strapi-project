variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 (update as per region)
}

variable "instance_type" {
  default = "t2.micro"
}

variable "docker_image_url" {
  description = "Docker image to pull and run"
}

variable "public_key_content" {
  description = "SSH Public Key content"
  type        = string
}

variable "subnet_id" {}
variable "vpc_id" {}
variable "public_key_path" {}
