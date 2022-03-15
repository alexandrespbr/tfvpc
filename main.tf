#TF Cloud
terraform {
  cloud {
    organization = "alexandresp-org"

    workspaces {
      name = "alexandresp"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

provider "aws" {
  region = "sa-east-1"
}

resource "aws_vpc" "EC2VPC" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    IsUsedForDeploy = "True"
    Name            = "VPCDev"
  }
}

resource "aws_subnet" "EC2Subnet1" {
  availability_zone       = "sa-east-1a"
  cidr_block              = "172.16.10.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = true
  tags = {
    Name = "VPCDev Public Subnet (AZ1)"
  }
}

resource "aws_subnet" "EC2Subnet2" {
  availability_zone       = "sa-east-1b"
  cidr_block              = "172.16.11.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = true
  tags = {
    Name = "VPCDev Public Subnet (AZ2)"
  }
}

resource "aws_subnet" "EC2Subnet3" {
  availability_zone       = "sa-east-1c"
  cidr_block              = "172.16.12.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = true
  tags = {
    Name = "VPCDev Public Subnet (AZ3)"
  }
}

resource "aws_subnet" "EC2Subnet4" {
  availability_zone       = "sa-east-1a"
  cidr_block              = "172.16.13.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
  tags = {
    Name = "VPCDev Private Subnet (AZ1)"
  }
}

resource "aws_subnet" "EC2Subnet5" {
  availability_zone       = "sa-east-1b"
  cidr_block              = "172.16.14.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
  tags = {
    Name = "VPCDev Private Subnet (AZ2)"
  }
}

resource "aws_subnet" "EC2Subnet6" {
  availability_zone       = "sa-east-1c"
  cidr_block              = "172.16.15.0/24"
  vpc_id                  = aws_vpc.EC2VPC.id
  map_public_ip_on_launch = false
  tags = {
    Name = "VPCDev Private Subnet (AZ3)"
  }
}

resource "aws_internet_gateway" "EC2InternetGateway" {
  tags = {
    Name = "VPCDev"
  }
  vpc_id = aws_vpc.EC2VPC.id
}

resource "aws_eip" "EC2EIP" {
  vpc = true
}

# resource "aws_eip_association" "EC2EIPAssociation" {
#     allocation_id = "eipalloc-35846035"
#     network_interface_id = "eni-0ef185fec9fa7c673"
#     private_ip_address = "172.16.11.202"
# }

resource "aws_eip" "EC2EIP2" {
  vpc = true
}

# resource "aws_eip_association" "EC2EIPAssociation2" {
#     allocation_id = "eipalloc-7b80647b"
#     network_interface_id = "eni-050e5a6ccd2e45c27"
#     private_ip_address = "172.16.10.240"
# }

resource "aws_eip" "EC2EIP3" {
  vpc = true
}

resource "aws_route_table" "EC2RouteTable1" {
  vpc_id = aws_vpc.EC2VPC.id
  tags = {
    Name = "VPCDev Public Routes"
  }
}

resource "aws_route_table" "EC2RouteTable2" {
  vpc_id = aws_vpc.EC2VPC.id
  tags = {
    Name = "VPCDev Private Routes (AZ1)"
  }
}

resource "aws_route_table" "EC2RouteTable3" {
  vpc_id = aws_vpc.EC2VPC.id
  tags = {
    Name = "VPCDev Private Routes (AZ2)"
  }
}

resource "aws_route_table" "EC2RouteTable4" {
  vpc_id = aws_vpc.EC2VPC.id
  tags = {
    Name = "VPCDev Private Routes (AZ3)"
  }
}

resource "aws_route_table" "EC2RouteTable5" {
  vpc_id = aws_vpc.EC2VPC.id
  tags = {
    Name = "VPCDev Private Routes (AZ4)"
  }
}

resource "aws_route" "EC2Route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.EC2InternetGateway.id
  route_table_id         = aws_route_table.EC2RouteTable1.id
}

resource "aws_route" "EC2Route1" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.EC2NatGateway.id
  route_table_id         = aws_route_table.EC2RouteTable2.id
}

resource "aws_route" "EC2Route2" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.EC2NatGateway2.id
  route_table_id         = aws_route_table.EC2RouteTable3.id
}

resource "aws_route" "EC2Route3" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.EC2NatGateway.id
  route_table_id         = aws_route_table.EC2RouteTable4.id
}

resource "aws_route" "EC2Route4" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.EC2NatGateway2.id
  route_table_id         = aws_route_table.EC2RouteTable5.id
}

resource "aws_nat_gateway" "EC2NatGateway" {
  subnet_id     = aws_subnet.EC2Subnet2.id
  allocation_id = aws_eip.EC2EIP.id
}

resource "aws_nat_gateway" "EC2NatGateway2" {
  subnet_id     = aws_subnet.EC2Subnet6.id
  allocation_id = aws_eip.EC2EIP2.id
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.EC2VPC.id
  service_name      = "com.amazonaws.sa-east-1.ssmmessages"
  policy            = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
  subnet_ids = [
    "${aws_subnet.EC2Subnet4.id}",
    "${aws_subnet.EC2Subnet5.id}"
  ]
  private_dns_enabled = true
  security_group_ids = [
    "${aws_security_group.EC2SecurityGroup.id}"
  ]
}

resource "aws_security_group" "EC2SecurityGroup" {
  description = "VPC Endpoint Ports Required"
  name        = "My SG Group VPC"
  tags        = {}
  vpc_id      = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint2" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.EC2VPC.id
  service_name      = "com.amazonaws.sa-east-1.ssm"
  policy            = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
  subnet_ids = [
    "${aws_subnet.EC2Subnet4.id}",
    "${aws_subnet.EC2Subnet5.id}"
  ]
  private_dns_enabled = true
  security_group_ids = [
    "${aws_security_group.EC2SecurityGroup.id}"
  ]
}

resource "aws_vpc_endpoint" "EC2VPCEndpoint3" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.EC2VPC.id
  service_name      = "com.amazonaws.sa-east-1.ec2messages"
  policy            = <<EOF
{
  "Statement": [
    {
      "Action": "*", 
      "Effect": "Allow", 
      "Principal": "*", 
      "Resource": "*"
    }
  ]
}
EOF
  subnet_ids = [
    "${aws_subnet.EC2Subnet4.id}",
    "${aws_subnet.EC2Subnet5.id}"
  ]
  private_dns_enabled = true
  security_group_ids = [
    "${aws_security_group.EC2SecurityGroup.id}"
  ]
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation" {
  route_table_id = aws_route_table.EC2RouteTable1.id
  subnet_id      = aws_subnet.EC2Subnet1.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation2" {
  route_table_id = aws_route_table.EC2RouteTable1.id
  subnet_id      = aws_subnet.EC2Subnet2.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation3" {
  route_table_id = aws_route_table.EC2RouteTable1.id
  subnet_id      = aws_subnet.EC2Subnet3.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation4" {
  route_table_id = aws_route_table.EC2RouteTable3.id
  subnet_id      = aws_subnet.EC2Subnet4.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation5" {
  route_table_id = aws_route_table.EC2RouteTable4.id
  subnet_id      = aws_subnet.EC2Subnet5.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation6" {
  route_table_id = aws_route_table.EC2RouteTable5.id
  subnet_id      = aws_subnet.EC2Subnet6.id
}

