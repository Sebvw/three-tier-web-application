resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  vpc_zone_identifier  = [aws_subnet.web-1.id, aws_subnet.web-2.id]
  min_size             = 2
  max_size             = 4
  target_group_arns    = [aws_lb_target_group.web_servers.arn]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "autoscaling_group"
    propagate_at_launch = true
  }
}


resource "aws_launch_configuration" "launch_configuration" {
  image_id             = "ami-03e88be9ecff64781"
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.application-sgrp.id]
  spot_price           = "0.0094"

  user_data            = file("install_apache.sh")


  lifecycle {
    create_before_destroy = true
  }
}
