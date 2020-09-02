terraform {
  backend "s3" {
    bucket = "terraform-states-punk-api-test"
    key    = "project/terraform.tfstate"
    region = "us-east-1"
  }
}