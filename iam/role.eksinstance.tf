resource "aws_iam_instance_profile" "eksinstanceprofile" {
  name = "eks-instance-profile"
  role = "${aws_iam_role.eksinstancerole.name}"
}

resource "aws_iam_role" "eksinstancerole" {
  name = "eks-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": [
                "ec2.amazonaws.com",
                "codebuild.amazonaws.com"
              ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "eksinstancepolicy" {
  name = "eks-instance-policy"
  role = "${aws_iam_role.eksinstancerole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
  ]
}
EOF
}