provider "aws" {
  region  = "eu-central-1"
  profile = "fofun"

  default_tags {
    tags = { Environment = "dev" }
  }
}
