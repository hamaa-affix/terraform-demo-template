/*
  for alb log
*/
resource "aws_s3_bucket" "alb_logs" {
  bucket = "alb_logs"
  acl    = "private"

  tags = {
    Name        = "alb log"
    Environment = var.env
  }
}
