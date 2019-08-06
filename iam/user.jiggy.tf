resource "aws_iam_user" "jiggy" {
  name = "jiggy"
  path = "/"
}

resource "aws_iam_user_group_membership" "jiggygroups" {
  user = "${aws_iam_user.jiggy.name}"

  groups = [
    "${aws_iam_group.users.name}",
    "${aws_iam_group.developers.name}",
  ]
}