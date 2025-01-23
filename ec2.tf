provider "aws" {
  region = "us-east-1"

}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "default vpc"
  }
}

data "aws_availability_zones" "available_zones" {

}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}

resource "aws_security_group" "ec2_Security_group" {
  name   = "sg"
  vpc_id = aws_default_vpc.default.id 

    ingress {
    description = "http access"
    from_port        = 80
    to_port          = 80 
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description = "ssh access"
    from_port        = 22
    to_port          = 22 
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

data "aws_ami" "amazon-linux2" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  } 
}
resource "aws_instance" "ec2_instance" {
  ami                     = aws_ami.amazon-linux2.id
  instance_type           = "t2.mirco"
  subnet_id =               aws_default_subnet.default_az1.id
  vpc_security_group_ids =  [aws_security_group.ec2_Security_group.id]
  user_data               = file("userdata.sh")
  tags = {
    Name = "sample ec2"
  }
}

output "public_ipv4_address" {
  
  value = aws_instance.ec2_instance.public_ip
}

