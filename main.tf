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
#SG linux jump server
resource "aws_security_group" "sg-linuxjumpserv" {
    vpc_id = aws_vpc.vpc_act3.id #vpc id
    name = "sg-linux-jumpserver"
    description = "Security group for Linux Jump Server"

    #ssh ingress and egress rules
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "10.10.0.0/24" ]
    }
    tags = {
        Name = "sg-linux-jumpserver"
    }
}

#SG web server 1

resource "aws_security_group" "sg-linux_webserver_1" {
  vpc_id = aws_vpc.vpc_act3.id #vpc id
  name = "sg-linux-webserver-1"
  description = "Security group for Linux Web Server 1"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "10.10.0.0/20" ]
  }
  #http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    tags = {
        Name = "sg-linux-webserver-1"
    }
}
#SG web server 2
resource "aws_security_group" "sg-linux_webserver_2" {
  vpc_id = aws_vpc.vpc_act3.id #vpc id
  name = "sg-linux-webserver-2"
  description = "Security group for Linux Web Server 2"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "10.10.0.0/24" ]
  }
  #http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    tags = {
        Name = "sg-linux-webserver-2"
    }
}

#SG web server 3
resource "aws_security_group" "sg-linux_webserver_3" {
  vpc_id = aws_vpc.vpc_act3.id #vpc id
  name = "sg-linux-webserver-3"
  description = "Security group for Linux Web Server 3"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "10.10.0.0/24" ]
  }
  #http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    tags = {
        Name = "sg-linux-webserver-3"
    }
}

#instancias

resource "aws_instance" "linux-jumpserver" {
    ami = "ami-084568db4383264d4" #amazon linux 2
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id #subnet id
    security_groups = [aws_security_group.sg-linuxjumpserv.name] #security group name
    key_name = "vockey" #key pair name
    associate_public_ip_address = true
    tags = {
        Name = "linux-jumpserver"
    }
  
}
resource "aws_instance" "linux-webserver-1" {
    ami = "ami-084568db4383264d4" #amazon linux 2
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id #subnet id
    security_groups = [aws_security_group.sg-linux_webserver_1.name] #security group name
    key_name = "vockey" #key pair name
    associate_public_ip_address = true
    tags = {
        Name = "linux-webserver-1"
    }
  
}
resource "aws_instance" "linux-webserver-2" {
    ami = "ami-084568db4383264d4" #amazon linux 2
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id #subnet id
    security_groups = [aws_security_group.sg-linux_webserver_2.name] #security group name
    key_name = "vockey" #key pair name
    associate_public_ip_address = true
    tags = {
        Name = "linux-webserver-2"
    }
  
}
resource "aws_instance" "linux-webserver-3" {
    ami = "ami-084568db4383264d4" #amazon linux 2
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id #subnet id
    security_groups = [aws_security_group.sg-linux_webserver_3.name] #security group name
    key_name = "vockey" #key pair name
    associate_public_ip_address = true
    tags = {
        Name = "linux-webserver-3"
    }
  
}
#output
output "linux-jumpserver_public_ip" {
    value = aws_instance.linux-jumpserver.public_ip
    description = "Public IP of the Linux Jump Server"
}
output "linux-webserver-1_public_ip" {
    value = aws_instance.linux-webserver-1.public_ip
    description = "Public IP of the Linux Web Server 1"
}
output "linux-webserver-2_public_ip" {
    value = aws_instance.linux-webserver-2.public_ip
    description = "Public IP of the Linux Web Server 2"
}
output "linux-webserver-3_public_ip" {
    value = aws_instance.linux-webserver-3.public_ip
    description = "Public IP of the Linux Web Server 3"
}