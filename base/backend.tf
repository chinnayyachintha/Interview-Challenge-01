
# terraform {
#   backend "s3" {
#     bucket         = "dev-example-terraform-infra"
#     key            = "Infra/base/statefile.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#     dynamodb_table = "dev-example-terraform-locks"
#   }
# }