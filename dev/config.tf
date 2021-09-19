terraform {
  required_version = "1.0.7"

  required_providers {
    aws = {
      aws = {
        source  = "hashicorp/aws"
        version = "3.48.0"
      }
    }
  }

  backend "s3" {
    bucket = var.tf_s3_bucket
    key    = var.state_file
    region = "ap-northeast-1"
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
