
resource "aws_instance" "svr1" {
  ami = "${var.svr1_ami_image}"
  subnet_id = "${aws_subnet.pub_subnet.id}"

  tags{
      Name="first_instance"
  }
  # Use instance eligible for Free Tier
  instance_type = "t2.micro"

  key_name = "${aws_key_pair.app_keypair.key_name}"
}

resource "aws_key_pair" "app_keypair" {
  public_key = "${file(var.public_keypair_path)}"
  key_name = "svr1_kp"
}

resource "aws_eip" "svr1-eip" {
  vpc = true
}

resource "aws_eip_association" "myapp_eip_assoc_svr1" {
  instance_id = "${aws_instance.svr1.id}"
  allocation_id = "${aws_eip.svr1-eip.id}"
}

output "svr1_elastic_ips" {
  value = "${aws_eip.svr1-eip.public_ip}"
}


