resource "aws_instance" "vm-cliente" {
  ami                         = "minha_imagem_WinSrv"
  instance_type               = "t3.large"
  associate_public_ip_address = false
  subnet_id                   = "subnet-09f950de2c1f2517e"
  security_groups             = [aws_security_group.sg-cliente.id]

  provisioner "local-exec" {
    command     = "C://padrao//configura.ps1"
    interpreter = ["Powershell"]
  }

  tags = {
    Name = "cliente-${terraform.workspace}"
  }
}

resource "aws_security_group" "sg-cliente" {
  description = "Allow RDP access by VPN"
  vpc_id      = "vpc-09460e9ee0da24b00"

  tags = {
    Name = "cliente-${terraform.workspace}"
  }

  ingress = [
    {
      description      = "Allow RDP"
      from_port        = "3389"
      to_port          = "3389"
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    },
    {
      description      = "Allow RDP"
      from_port        = "3389"
      to_port          = "3389"
      protocol         = "tcp"
      cidr_blocks      = ["10.2.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]
  egress = [
    {
      description      = "Allow "
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["10.1.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    },
    {
      description      = "Allow RDP"
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["10.2.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]
}

output "private-ip-ec2" {
  value = aws_instance.vm-cliente.private_ip
}
