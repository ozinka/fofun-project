provider "aws" {
  region  = "eu-central-1"
  profile = "fofun"
  default_tags {
    tags = { environment = "dev" }
  }
}

provider "aws" {
  alias   = "ozi"
  region  = "eu-central-1"
  profile = "fofun"
  assume_role {
    role_arn = "arn:aws:iam::122317880364:role/fofun_route53"
  }
}

terraform {
  backend "s3" {
    bucket         = "fofun-terraform"
    key            = "fofun.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf_state_tbl"
    profile        = "fofun"
  }
}
