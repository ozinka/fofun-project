resource "aws_instance" "web_server" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.amazon_linux_2.id
  iam_instance_profile        = aws_iam_instance_profile.fofun_ec2_iam_profile.name
  user_data                   = file("conf/user_data_jenkins.sh")
  vpc_security_group_ids      = [aws_security_group.ec2_fofun_sg.id]
  subnet_id                   = aws_subnet.fofun_sn1.id
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 15
    delete_on_termination = true
    encrypted             = true
  }
  tags = { "Name" = "fofun-ec2" }
}


