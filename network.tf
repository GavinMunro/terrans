resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = "${aws_default_vpc.default.id}"
  service_name = "com.amazonaws.us-east-2.s3"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_default_vpc.default.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"
    tags {
        Name = "Default subnet for us-east-2"
    }
}

//resource "aws_subnet" "pub_subnet" {
//  cidr_block = "192.168.10.0/24"
//  vpc_id = "${aws_default_vpc.default.id}"
//  tags {
//    Name = "Svr1 Subnet"
//  }
//  depends_on = ["aws_vpc_dhcp_options_association.dns_resolver"]
//}
//
//resource "aws_internet_gateway" "app_igw" {
//  vpc_id = "${aws_default_vpc.default.id}"
//}

//resource "aws_vpc_dhcp_options" "dns_resolver" {
//  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
//}

//resource "aws_vpc_dhcp_options_association" "dns_resolver" {
//  vpc_id = "${aws_default_vpc.default.id}"
//  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
//}
