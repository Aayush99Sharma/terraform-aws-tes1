terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "aayush8276"
    workspaces {
      prefix = "terraform-"
    }
  }
}

