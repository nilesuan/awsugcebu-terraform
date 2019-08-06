resource "aws_iam_user" "allan" {
  name = "allan"
  path = "/"
}

resource "aws_iam_user_group_membership" "allangroups" {
  user = "${aws_iam_user.allan.name}"

  groups = [
    "${aws_iam_group.admins.name}",
  ]
}