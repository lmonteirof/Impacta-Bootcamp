resource "aws_instance" "vm-cliente" {
  ami                         = "cliente-srvapp-image"
  instance_type               = "t2.large"
  subnet_id                   = "cliente-private-subnet-id"
  associate_public_ip_address = false
  vpc_id                      = "minha-vpc-id"
  cidr_block                  = "10.1.0.0/16"
  availavailability_zone      = "us-east-1"

  provisioner "local-exec" {
    command = "C:\\padrao\\configura.ps1"
    interpreter = ["Powershell"]
  }

  tags = {
    Name = format("cliente-",terraform.workspace)
  }
}

resource "aws_security_group" "sg-cliente" {
  name        = format("sg-", terraform.workspace)
  description = "Allow RDP access by VPN"
  vpc_id      = "minha-private-subnet-id"

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
