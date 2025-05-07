/*
-------------------------------------------
Variables (expected in variables.tf)
-------------------------------------------
variable "instance_type"
variable "public_subnet_cidr"
variable "ssh_cidr"
*/

/*
-------------------------------------------
EC2 Instance
-------------------------------------------
*/

resource "aws_instance" "web" {
  ami = "ami-0dfe0f1abee59c78d" # Amazon Linux 2023 EU-WEST-2
  instance_type = var.instance_type
  key_name = "Flask_WebServer"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_nic.id
  }

  tags = {
    Name = "Portfolio Flask WebServer"
  }
}

/*
-------------------------------------------
Virtual Private Cloud
-------------------------------------------
*/

resource "aws_vpc" "portfolio" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Portfolio Project VPC"
  }
}

/*
-------------------------------------------
Public Subnet
-------------------------------------------
*/

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.portfolio.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "Public Subnet"
  }
}

/*
-------------------------------------------
Route Table
-------------------------------------------
*/

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.portfolio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

/*
-------------------------------------------
Route Table Association
-------------------------------------------
*/

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

/*
-------------------------------------------
Internet Gateway
-------------------------------------------
*/

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.portfolio.id

  tags = {
    Name = "Main IGW"
  }
}

/*
-------------------------------------------
Security Group - HTTP/HTTPS Access
-------------------------------------------
*/

resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "Allow HTTP/HTTPS inbound"
  vpc_id = aws_vpc.portfolio.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" #'-1' = any protocol
    cidr_blocks = ["0.0.0.0/0"] #any IP address
  }

  tags = {
    Name = "Web Access"
  }
}

/*
-------------------------------------------
Security Group - SSH (from my IP address only)
-------------------------------------------
*/

resource "aws_security_group" "ssh_access" {
  name = "allow-ssh-from-my-ip-only"
  description = "Allow SSH access from my IP"
  vpc_id = aws_vpc.portfolio.id

  ingress {
    description = "SSH from my IP"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Access"
  }
}

/*
-------------------------------------------
Network Interface
-------------------------------------------
*/

resource "aws_network_interface" "web_nic" {
  subnet_id = aws_subnet.public.id
  private_ips = ["10.0.1.10"]
  security_groups = [
    aws_security_group.allow_web.id,
    aws_security_group.ssh_access.id
  ]

  tags = {
    Name = "WebServer ENI"
  }
}

/*
-------------------------------------------
Elastic IP
-------------------------------------------
*/

resource "aws_eip" "web_eip" {
  domain = "vpc"
  network_interface = aws_network_interface.web_nic.id
  associate_with_private_ip = "10.0.1.10"
  depends_on = [
    aws_instance.web,
    aws_network_interface.web_nic,
    aws_internet_gateway.igw
  ]
}