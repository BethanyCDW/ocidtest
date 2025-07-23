terraform {
  backend "s3" {
    bucket = "bb-oicd-test"    # Replace with your S3 bucket name
    key    = "iam-role/terraform.tfstate"   # Replace with your desired key/path
    region = "us-east-2"                     # Replace with your bucket region
    encrypt = true
  }
}