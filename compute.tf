
resource "aws_instance" "svr1" {
  ami = "${var.svr1_ami_image}"
  # Use instance eligible for Free Tier
  instance_type = "t2.micro"
  tags{
      Name="Server #1"
  }
  subnet_id = "${aws_default_subnet.default_az1.id}"

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p 8080 &
  EOF

  key_name = "${aws_key_pair.app_keypair.key_name}"

  vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

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

output "public_ip" {
  value = "${aws_instance.svr1.public_ip}"
}



