terraform {
  backend "s3" {
    bucket         = "devops-presentation-toto"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_state"
  }
}