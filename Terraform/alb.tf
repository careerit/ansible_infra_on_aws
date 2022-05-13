resource "aws_lb" "myappweb" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  
  # enable_deletion_protection = true
  
  tags = {
    Name        = "${var.prefix}-alb"
    Project     = var.project
    Environment = var.environment
  }
}


resource "aws_lb_target_group" "myappweb" {
  name     = "${var.prefix}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myapp.id
  
  health_check { 
    enabled = true
    healthy_threshold = 5
    unhealthy_threshold= 2
    interval = 10
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "myappweb" {
  count = var.webnodes
  target_group_arn = aws_lb_target_group.myappweb.arn
  target_id        = element(aws_instance.web.*.id, count.index)
  port             = 80
}

resource "aws_lb_listener" "myappweb" {
  load_balancer_arn = aws_lb.myappweb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myappweb.arn
  }
  

}



resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.myappweb.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["/"]
    }
  }
 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myappweb.arn
  }

 
}