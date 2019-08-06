resource "aws_iam_group" "users" {
  name = "users"
  path = "/"
}

resource "aws_iam_policy_attachment" "usersiamselfmanageservicespecificcredentials" {
  name       = "users-iam-self-manage-service-specific-credentials"
  groups     = ["${aws_iam_group.users.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMSelfManageServiceSpecificCredentials"
}

resource "aws_iam_policy_attachment" "usersiamuserchangepassword" {
  name       = "users-iam-user-change-password"
  groups     = ["${aws_iam_group.users.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_policy_attachment" "usersiamreadonlyaccess" {
  name       = "users-iam-read-only-access"
  groups     = ["${aws_iam_group.users.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "usersiamusersshkeys" {
  name       = "users-iam-user-ssh-keys"
  groups     = ["${aws_iam_group.users.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMUserSSHKeys"
}