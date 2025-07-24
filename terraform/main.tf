provider "aws" {
  region = "us-east-1"
}

variable "image_tag" {
  description = "Docker image tag to pull and run"
  type        = string
}

# Create VPC
resource "aws_vpc" "strapi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "strapi-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "strapi_subnet" {
  vpc_id                  = aws_vpc.strapi_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "strapi-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "strapi_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
  tags = {
    Name = "strapi-igw"
  }
}

# Create Route Table
resource "aws_route_table" "strapi_rt" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_igw.id
  }
  tags = {
    Name = "strapi-rt"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "strapi_rta" {
  subnet_id      = aws_subnet.strapi_subnet.id
  route_table_id = aws_route_table.strapi_rt.id
}

# Security Group for SSH and HTTP
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.strapi_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

# EC2 Key Pair - You must create this in AWS Console or import
resource "aws_key_pair" "strapi_key" {
  key_name   = "strapi_key"
public_key = file("C:/Users/KIIT0001/.ssh/strapi_key.pub") # Use absolute path for Windows

}

# Launch EC2 Instance
resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-053b0d53c279acc90" # Ubuntu 22.04 LTS in us-east-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.strapi_subnet.id
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]
  key_name                    = aws_key_pair.strapi_key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              systemctl start docker
              docker run -d -p 80:1337 ${var.image_tag}
              EOF

  tags = {
    Name = "strapi-ec2"
  }
}


