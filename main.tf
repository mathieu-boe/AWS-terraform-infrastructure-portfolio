#EC2 Instance
resource "aws_instance" "Web" {
  ami = "ami-0dfe0f1abee59c78d" #Amazon Linux 2023 EU-WEST-2
  instance_type = var.instance_type #see variables.tf
  key_name = "Flask_WebServer"
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  tags = {
    Name = "Portfolio Flask WebServer"
  }
}

#Defining a Security Group that allows HTTP(S) & SSH inbound traffic
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}