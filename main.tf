provider "aws" {
    region = "us-east-1"
}
#create a vpc
resource "aws_vpc" "vpc_act3" {
  cidr_block = "10.10.0.0/20" #identify the range of IP addresses for the VPC
  enable_dns_support = true
  enable_dns_hostnames = true #enable DNS hostnames for the VPC  
    tags = {
        Name = "vpc_act3"
    }
}

resource "aws_subnet" "public_subnet" {
  vpc_id =aws_vpc.vpc_act3.id #vpc id
  cidr_block = "10.10.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc_act3.id #vpc id
    tags = {
        Name = "igw"
    }
  
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc_act3.id #vpc id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id #internet gateway id   

    }
    tags = {
        Name = "public_route_table"
    }
  
}

resource "aws_route_table_association" "route_association" {
    subnet_id = aws_subnet.public_subnet.id #subnet id
    route_table_id = aws_route_table.public_route_table.id #route table id
  
}