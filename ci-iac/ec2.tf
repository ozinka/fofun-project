resource "aws_instance" "web_server" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.amazon_linux_2.id
  iam_instance_profile        = aws_iam_instance_profile.fofun_ec2_iam_profile.name
  user_data                   = file("conf/jenkins_user_data.sh")
  vpc_security_group_ids      = [aws_security_group.ec2_fofun_sg.id]
  subnet_id                   = aws_subnet.fofun_sn1.id
  associate_public_ip_address = true
  tags                        = { "Name" = "fofun-ec2" }
}


