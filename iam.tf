# Setup for IAM role needed to setup an ec2 cluster logs
resource "aws_iam_role" "tf-ec2-master" {
  name = "terraform-ec2-cluster"

  assume_role_policy = <<POLICY
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
POLICY
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.tf-ec2-master.name
}


resource "aws_iam_role_policy_attachment" "tf-cluster-AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.tf-ec2-master.name
}

resource "aws_iam_role_policy_attachment" "tf-cluster-CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.tf-ec2-master.name
}