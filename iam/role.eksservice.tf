resource "aws_iam_role" "eksservicerole" {
  name = "eks-service-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eksclusterpolicy" {
  role       = "${aws_iam_role.eksservicerole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eksservicepolicy" {
  role       = "${aws_iam_role.eksservicerole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}