provider "aws" {
  region  = "eu-central-1"
  profile = "fofun"
  default_tags {
    tags = { environment = "dev" }
  }
}


//provider "aws" {
//  alias = "oz"
//  assume_role {
//    role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
//    session_name = "SESSION_NAME"
//    external_id  = "EXTERNAL_ID"
//  }
//}

terraform {
  backend "s3" {
    bucket         = "fofun-terraform"
    key            = "fofun.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf_state_tbl"
    profile        = "fofun"
  }
}
