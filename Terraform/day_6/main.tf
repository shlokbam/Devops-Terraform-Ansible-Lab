provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
    description = "AMI ID for EC2 instance"
}

variable "instance_type" {
    description = "Instance type for EC2 instance"
    type = map(string)

    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.xlarge"
    }
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_id = var.ami_id
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}