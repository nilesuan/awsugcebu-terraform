resource "aws_iam_group" "admins" {
  name = "admins"
  path = "/"
}

resource "aws_iam_policy_attachment" "adminsadministratoraccess" {
  name       = "admins-administrator-access"
  groups      = ["${aws_iam_group.admins.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}