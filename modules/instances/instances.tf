provider "aws" {
   profile    = "${var.aws_profile}"
   region     = "${var.aws_region}"
}

resource "aws_instance" "rancherServer" {
  instance_type = "${var.instance_type}"
  ami = "${var.ec2_ami}"
  tags {
    Name = "Rancher Server"
  }

  key_name = "${var.aws_key_name_id}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id = "${var.subnet_id}"
# FIXME: import this
#   depends_on = ["aws_internet_gateway.gw"]


  provisioner "remote-exec" {
    inline = [ 
      "sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:v1.6.3" 
    ]

    connection {
      type         = "ssh"
      user         = "ubuntu"
      private_key  = "${file(var.private_key_path)}"
    }
  }
}
