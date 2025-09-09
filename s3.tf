terraform {
  backend "s3" {
    bucket         = "my-terraform-bucket"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
