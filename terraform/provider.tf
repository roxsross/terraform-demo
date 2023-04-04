provider "aws" {
  region = "us-east-1"
  # access_key = ""
  # secret_key = ""
  #shared_credentials_files = ".aws/credentials"
}

terraform {
  backend "s3" {
    bucket  = "training-tfstate-demo"
    region  = "us-east-1"
    encrypt = true
    key     = "demo/deploy.tfstate"
  }
}