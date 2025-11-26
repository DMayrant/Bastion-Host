resource "aws_sns_topic" "asg_notifications" {
  name = "my-asg-notifications-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "email"
  endpoint  = "mayrantd@gmail.com"
}

resource "aws_autoscaling_notification" "asg_notification" {
  group_names = [aws_autoscaling_group.ec2_asg.name]
  topic_arn   = aws_sns_topic.asg_notifications.arn

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}
