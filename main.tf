provider "aws" {
  region = "us-east-1"
  access_key = "*****"
  secret_key = "*****"
}

resource "aws_vpc" "vpc-01" {
    cidr_block = "10.0.0.0/16"
    assign_generated_ipv6_cidr_block = true

    tags = {
        Name = "Terraform-VPC-01"
    }
}

resource "aws_internet_gateway" "internet-gateway-01" {
    vpc_id = aws_vpc.vpc-01.id

    tags = {
        Name = "Terraform-Internet-Gateway-01"
    }
}

resource "aws_egress_only_internet_gateway" "egress-gateway-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "Terraform-Egress-Gateway-01"
  }
}

resource "aws_route_table" "route-table-01" {
    vpc_id = aws_vpc.vpc-01.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway-01.id
    }

    route {
        ipv6_cidr_block        = "::/0"
        egress_only_gateway_id = aws_egress_only_internet_gateway.egress-gateway-01.id
    }

    tags = {
        Name = "Terraform-Route-Table-01"
    }
}

resource "aws_subnet" "subnet-01" {
    vpc_id = aws_vpc.vpc-01.id
    cidr_block = "10.0.1.0/24"
    depends_on = [aws_internet_gateway.internet-gateway-01]
    
    tags = {
        Name = "Terraform-Subnet-01"
    }
}

resource "aws_route_table_association" "rt-association-01" {
  subnet_id      = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.route-table-01.id
}

resource "aws_security_group" "security-group-01" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Security-Group-01"
  }
}

resource "aws_network_interface" "nic-01" {
    subnet_id       = aws_subnet.subnet-01.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.security-group-01.id]

    tags = {
      Name = "Terraform-NIC-01"
    }
}

resource "aws_eip" "eip-01" {
    domain = "vpc"
    #network_interface = aws_network_interface.nic-01.id
    instance = aws_instance.instance-01.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.internet-gateway-01]

    tags = {
      Name = "Terraform-EIP-01"
    }
}

resource "aws_instance" "instance-01" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  key_name = "terraform-01"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nic-01.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

  tags = {
    Name = "Terraform-Server-01"
  }
}

output "server_private_ip" {
  value = aws_instance.instance-01.private_ip

}

output "server_id" {
  value = aws_instance.instance-01.id
}