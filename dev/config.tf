terraform {
  required_version = "1.0.7"
  backend "s3" {
    bucket = "terraform.demo"
    key    = "demo.terraform.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.48.0"
    }
  }
}

provider "aws" { //東京リージョン用
  region = var.region
}

/*cloudfrontを使用する場合はap-northeastのregion定義が必要。acmの発行ができないから*/
#cloudfront用のregionを追加
provider "aws" {
  region = "us-east-1"
  alias  = "virgnia"
}
