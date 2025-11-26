
resource "aws_security_group" "linux_sg" {
  vpc_id = aws_vpc.main_vpc.id


  tags = merge(local.common_tags, {
    Name = "linux-SG"
  })
}

resource "aws_security_group_rule" "allow_ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.linux_sg.id
  description       = "Allow SSH connection to linux server"
}

resource "aws_security_group_rule" "allow_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.linux_sg.id
  description       = "Allow HTTP ingress to linux server"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.linux_sg.id
  description       = "Allow all outbound traffic"
}


resource "aws_security_group" "alb_sg" {
  name        = "alb_security_group"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
  }
}