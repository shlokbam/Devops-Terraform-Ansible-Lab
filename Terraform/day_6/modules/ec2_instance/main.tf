provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
    description = "AMI ID for EC2 instance"
}

variable "instance_type" {
    description = "Instance type for EC2 instance"
}
resource "aws_instance" "example" {
  ami = var.ami_id
  instance_type = var.instance_type
}