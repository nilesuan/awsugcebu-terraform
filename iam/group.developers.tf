resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/"
}

resource "aws_iam_policy_attachment" "developerscloudwatchreadonlyaccess" {
  name       = "developers-cloud-watch-read-only-access"
  groups     = ["${aws_iam_group.developers.name}"]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "developersawscodecommitpoweruser" {
  name       = "developers-aws-code-commit-power-user"
  groups     = ["${aws_iam_group.developers.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource "aws_iam_policy_attachment" "developerss3readonlyaccess" {
  name       = "developers-cloud-watch-read-only-access"
  groups     = ["${aws_iam_group.developers.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy" "developersgrouppolicy" {
  name  = "developers-group-policy"
  group = "${aws_iam_group.developers.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::awsugcebu.org/*"
      ]
    }
  ]
}
EOF
}