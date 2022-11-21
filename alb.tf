resource "aws_lb" "main" {
  name               = "staircase-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-057e24e5b35911b77"]
  subnets            = ["subnet-065e7dd9f48aadde1","subnet-0d31352b95d9036f5"]
 
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "main" {
  name        = "python-targetgp"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = "vpc-0d4e87f8c7b7eedde"
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
   type = "forward"
   target_group_arn=aws_alb_target_group.main.arn
  }
  
}