resource "aws_instance" "web-server" {
  key_name             = "fo-fun.pem"
  instance_type        = "t3.micro"
  ami                  = data.aws_ami.amazon-linux-2.id
  iam_instance_profile = aws_iam_policy.ec2_fofun_policy.id

  user_data = templatefile("conf/user_data.tpl")

  security_groups             = [aws_security_group.ec2_ec2_sg.id]
  subnet_id                   = aws_subnet.fofun-sn1.id
  associate_public_ip_address = true
}