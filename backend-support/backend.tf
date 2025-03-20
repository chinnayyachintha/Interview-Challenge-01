terraform {
  backend "s3" {
    bucket         = "devexample-terraform-infra"
    key            = "Infra/backend-support/statefile.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "devexample-terraform-locks"
  }
}