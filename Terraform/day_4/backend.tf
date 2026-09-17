terraform {
  backend "s3" {
    bucket = "<YOUR_S3_BUCKET_NAME>"
    key    = "<YOUR_KEY_PATH>/terraform.tfstate"
    region = "us-east-1"
  }
}