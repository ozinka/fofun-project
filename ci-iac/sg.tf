#---------------------------------------------------
# EC2 security group
#---------------------------------------------------
resource "aws_security_group" "ec2_fofun_sg" {
  name        = "ec2-fofun-sg"
  description = "HTTP traffic to Web EC2"
  vpc_id      = aws_vpc.fofun_vpc.id
  ingress {
    from_port       = 8080
    protocol        = "tcp"
    to_port         = 8080
    security_groups = [aws_security_group.elb_fofun_sg.id]
    description     = "HTTP access to jenkins"
  }
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.elb_fofun_sg.id]
    description     = "HTTP access to web"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All OUT"
  }
  tags = { Name = "ec2-fofun-sg" }
  lifecycle { create_before_destroy = true }
}

#---------------------------------------------------
# ELB security group
#---------------------------------------------------
resource "aws_security_group" "elb_fofun_sg" {
  name        = "elb-fofun-sg"
  description = "HTTP traffic to ELB"
  vpc_id      = aws_vpc.fofun_vpc.id
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access to fofun project"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All OUT"
  }
  tags = { Name = "elb-fofun-sg" }
  lifecycle { create_before_destroy = true }
}