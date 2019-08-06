resource "aws_iam_user" "joey" {
  name = "joey"
  path = "/"
}

resource "aws_iam_user_group_membership" "joeygroups" {
  user = "${aws_iam_user.joey.name}"

  groups = [
    "${aws_iam_group.admins.name}",
  ]
}