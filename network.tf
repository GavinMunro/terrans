resource "aws_vpc" "app_vpc" {
  cidr_block = "192.168.0.0/16"
  tags {
    Name = "Svr1 VPC"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.app_vpc.id}"
  service_name = "com.amazonaws.us-east-2.s3"
}

resource "aws_security_group" "Svr1" {
  name = "Svr1SecGrp"
  vpc_id = "${aws_vpc.app_vpc.id}"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "pub_subnet" {
  cidr_block = "192.168.10.0/24"
  vpc_id = "${aws_vpc.app_vpc.id}"
  tags {
    Name = "Svr1 Subnet"
  }
  depends_on = ["aws_vpc_dhcp_options_association.dns_resolver"]
}

resource "aws_internet_gateway" "app_igw" {
  vpc_id = "${aws_vpc.app_vpc.id}"
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.app_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
