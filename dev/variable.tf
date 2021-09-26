variable "region" {
  type        = string
  default     = "ap-northeast-1"
}

variable "env" {
  type        = string
  default     = "development"
}

variable "azs" {
  type = list
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}
# /variable "rds_passwored" {}
