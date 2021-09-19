variable "region" {
  type        = string
  default     = "ap-northeast-1"
}

variable "tf_s3_bucket" {
  default = "cterraform.demo"
}

variable "state_file" {
  default = "demo.terraform.tfstate"
}

variable "rds_passwored" {}
