/*
  alb security group
*/
resource "aws_security_group" "alb" {
  name        = "security group alb"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.app_env.id

  ingress  {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-for-security-group"
  }
}

/*
  web security group
*/
resource "aws_security_group" "web" {
  name        = "web security group"
  description = "security group for web"
  vpc_id      = aws_vpc.app_env.id

  ingress  {
      description      = "alb"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      security_groups  = [aws_security_group.alb.id]
  }


  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-for-security-group"
  }
}

/*
  rds security group
*/
resource "aws_security_group" "rds" {
  name        = "security group rds"
  description = "security group for rds"
  vpc_id      = aws_vpc.app_env.id

  ingress  {
      description      = "web"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      security_groups  = [aws_security_group.web.id]
  }

  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-for-security-group"
  }
}
