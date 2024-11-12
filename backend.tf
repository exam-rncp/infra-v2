# terraform {
#   backend "s3" {
#     bucket  = "aws-sock-shop-mai24-infra-state.file"
#     key     = "global/infra/terraform.tfstate"
#     region  = "eu-west-3"
#     encrypt = true
#   }
# }