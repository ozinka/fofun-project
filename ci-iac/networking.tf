resource "aws_vpc" "fofun-vpc" {
  cidr_block = "10.12.0.0/16"
  tags       = { Name = "fofun-vpc" }
}

resource "aws_subnet" "fofun-sn1" {
  vpc_id            = aws_vpc.fofun-vpc.id
  cidr_block        = "10.12.13.0/24"
  availability_zone = "eu-central-1a"
  tags              = { Name = "public-fofun-sn" }
}
resource "aws_subnet" "fofun-sn2" {
  vpc_id            = aws_vpc.fofun-vpc.id
  cidr_block        = "10.12.14.0/24"
  availability_zone = "eu-central-1c"
  tags              = { Name = "public-fofun-sn" }
}

resource "aws_default_route_table" "fofun-public-rt" {
  default_route_table_id = aws_vpc.fofun-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fofun-igw.id
  }

  tags = { Name = "fofun-public-rt" }
}

resource "aws_internet_gateway" "fofun-igw" {
  vpc_id = aws_vpc.fofun-vpc.id
  tags   = { Name = "fofun-igw" }
}
