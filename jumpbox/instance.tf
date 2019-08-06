resource "aws_launch_configuration" "launchconfig" {
  image_id                    = "ami-07a3bd4944eb120a0"
  instance_type               = "t3.small"
  iam_instance_profile        = "${aws_iam_instance_profile.instanceprofile.id}"
  key_name                    = "public"
  security_groups             = ["${aws_security_group.securitygroup.id}"]
  associate_public_ip_address = true
  enable_monitoring           = true
  user_data                   = "${data.template_file.userdata.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "100"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscalinggroup" {
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.launchconfig.id}"
  vpc_zone_identifier       = ["${data.aws_subnet.publicsubnet.*.id}"]

  termination_policies = [
    "OldestLaunchConfiguration",
    "ClosestToNextInstanceHour",
    "OldestInstance",
    "NewestInstance",
    "AllocationStrategy",
    "Default",
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.shortname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "administration"
    propagate_at_launch = true
  }

  tag {
    key                 = "Stack"
    value               = "${var.shortname}"
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpuhigh" {
  alarm_name          = "${var.shortname}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoscalinggroup.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpulow" {
  alarm_name          = "${var.shortname}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoscalinggroup.name}"
  }
}

resource "aws_iam_instance_profile" "instanceprofile" {
  name = "${var.shortname}-instance-profile"
  role = "${data.aws_iam_role.instancerole.name}"
}