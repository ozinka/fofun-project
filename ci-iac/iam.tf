resource "aws_iam_role" "ec2_fofun_iam_role" {
  name               = "ec2-fofun-iam-role"
  tags               = { Name = "ec2-fofun-iam-role" }
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2_fofun_policy" {
  name        = "ec2_fofun_policy"
  path        = "/"
  description = "This policy provides full S3 access and SSM"
  policy = templatefile("conf/ec2_fofun_policy.json", {
    bucket = aws_s3_bucket.fofun_bucket.bucket
  })
}

resource "aws_iam_instance_profile" "fofun_ec2_iam_profile" {
  name = "fofun-ec2-iam-profile"
  role = aws_iam_role.ec2_fofun_iam_role.name
}

resource "aws_iam_role_policy_attachment" "fofun_policy_atch" {
  policy_arn = aws_iam_policy.ec2_fofun_policy.arn
  role       = aws_iam_role.ec2_fofun_iam_role.name
}

resource "aws_iam_role_policy_attachment" "fofun_policy_atch_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_fofun_iam_role.name
}

//resource "aws_ssm_activation" "ssm_activation" {
//  name               = "fofun_ssm_activation"
//  description        = "fofun ssm activation"
//  iam_role           = aws_iam_role.ec2_fofun_iam_role.id
//  registration_limit = "5"
//  depends_on         = [aws_iam_role_policy_attachment.fofun_policy_atch_ssm]
//}

# Terraform example of SSM policy assignment