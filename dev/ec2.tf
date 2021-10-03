/*
  このdata sourcedから最新のamazon linuxのamiを取得
*/
data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

/*
  EC2 * 2
*/
resource "aws_instance" "web" {
  count         =  2
  ami           = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private[count.index].id
  key_name      = aws_key_pair.auth.id
  monitoring    = true

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = "8"
  }

  tags = {
    Name = "web"
  }

  security_groups = [aws_security_group.web.id]
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_eip" "bastion" {
  count = 2
  instance = aws_instance.web[count.index].id
  vpc      = true

  tags = {
    Name = "eip-for-web"
  }
}
