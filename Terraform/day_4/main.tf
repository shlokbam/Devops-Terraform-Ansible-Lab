provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "<YOUR_S3_BUCKET_NAME>"
  
}