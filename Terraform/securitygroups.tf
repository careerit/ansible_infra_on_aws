resource "aws_security_group" "bastion" {
  name        = "sg_for_bastion"
  description = "Allow traffic to bastion from home"
  vpc_id      = aws_vpc.myapp.id

  tags = {
    Name        = "${var.prefix}-bastion-sg"
    Project     = var.project
    Environment = var.environment
  }
}


resource "aws_security_group_rule" "bastionIngress" {
  count             = length(var.bastion_sg_rules)
  type              = "ingress"
  from_port         = element(var.bastion_sg_rules, count.index)
  to_port           = element(var.bastion_sg_rules, count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}


resource "aws_security_group_rule" "bastionEgress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}



resource "aws_security_group" "web" {
  name        = "sg_for_web"
  description = "SG for Web instances"
  vpc_id      = aws_vpc.myapp.id

  tags = {
    Name        = "${var.prefix}-web-sg"
    Project     = var.project
    Environment = var.environment
  }
}




resource "aws_security_group_rule" "webIngress" {
  count             = length(var.web_sg_rules)
  type              = "ingress"
  from_port         = element(var.web_sg_rules, count.index)
  to_port           = element(var.web_sg_rules, count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}


resource "aws_security_group_rule" "webEgress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.web.id
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_security_group_rule" "webBastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.web.id
}


resource "aws_security_group" "alb" {
  name        = "sg_for_alb"
  description = "Allow traffic to alb from home"
  vpc_id      = aws_vpc.myapp.id

  tags = {
    Name        = "${var.prefix}-alb-sg"
    Project     = var.project
    Environment = var.environment
  }
}


resource "aws_security_group_rule" "albIngress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}



resource "aws_security_group_rule" "albEgress" {
    type              = "egress"
    to_port           = 0
    protocol          = "-1"
    from_port         = 0
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.alb.id
  }
  

  resource "aws_security_group" "db" {
  name        = "sg_for_db"
  description = "SG for db instances"
  vpc_id      = aws_vpc.myapp.id

  tags = {
    Name        = "${var.prefix}-db-sg"
    Project     = var.project
    Environment = var.environment
  }
}




resource "aws_security_group_rule" "dbIngress" {
  count             = length(var.db_sg_rules)
  type              = "ingress"
  from_port         = "3306"
  to_port           = "3306"
  protocol          = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id = aws_security_group.db.id
}


resource "aws_security_group_rule" "dbEgress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.db.id
  cidr_blocks       = ["0.0.0.0/0"]
}





resource "aws_security_group_rule" "dbBastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.db.id
}
