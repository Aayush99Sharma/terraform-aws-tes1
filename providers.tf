
provider "aws" {
  region = "us-west-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_access_key = var.AWS_SECRET_ACCESS_KEY

}

# Add other provider configurations if necessary with different aliases
