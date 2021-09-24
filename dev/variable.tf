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

# /variable "rds_passwored" {}
