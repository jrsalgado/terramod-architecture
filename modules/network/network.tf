# AWS provider

provider "aws" {
   profile    = "${var.aws_profile}"
   region     = "${var.aws_region}"
}

# Key pair
resource "aws_key_pair" "auth" {
  key_name  ="${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# VPC

resource "aws_vpc" "Site1-vpc1" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags {
    Name = "Site1-vpc1"
  }
}

# Subnet

resource "aws_subnet" "Site1-subnet1" {
  vpc_id     = "${aws_vpc.Site1-vpc1.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Site1-subnet1"
  }
}

# Route Table

resource "aws_route_table" "Site1-rt" {
  vpc_id = "${aws_vpc.Site1-vpc1.id}"
  route {
    cidr_block = "0.0.0.0/0"
	  gateway_id = "${aws_internet_gateway.Site1-igw.id}"
	}
  tags {
	Name = "Site1-rt"
  }
}

# Route Table Association

resource "aws_route_table_association" "public_assoc" {
  subnet_id = "${aws_subnet.Site1-subnet1.id}"
  route_table_id = "${aws_route_table.Site1-rt.id}"
}

# Internet Gateway

resource "aws_internet_gateway" "Site1-igw" {
  vpc_id = "${aws_vpc.Site1-vpc1.id}"
  tags {
    Name = "Site1-igw"
  }
}

# Security Group
resource "aws_security_group" "Site1-sg" {
  name        = "Site1 Rancher Server sg"
  description = "Rancher Server sg"
  vpc_id      = "${aws_vpc.Site1-vpc1.id}"

  # Internet egress
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # Internet ingress
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # TODO: limit access to rancher Host only
  ingress {
    from_port   = 2376
    to_port     = 2378
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # TODO: limit access to rancher Host only
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # TODO: limit access to rancher Host only
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "aws_security_group-Site1-id" {
  value = "${aws_security_group.Site1-sg.id}"
}

output "aws_subnet_Site1_id" {
  value = "${aws_subnet.Site1-subnet1.id}"
}

output "aws_key_name_id" {
  value = "${aws_key_pair.auth.id}"
}