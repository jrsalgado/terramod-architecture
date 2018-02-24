// Rancher host
resource "aws_instance" "RancherHost1" {
  instance_type = "${var.instance_type}"
  ami = "${var.ec2_ami}"
  tags {
    Name = "Rancher Host 1"
  }

  key_name = "${var.aws_key_name_id}"
  vpc_security_group_ids = ["${var.security_group_rancher_host_id}"]
  subnet_id = "${var.subnet_id}"
  

  # TODO: get variables from rancher server config   
  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.5 ${var.rancher_host_registration_url}"
    ]

    connection {
      type         = "ssh"
      user         = "ubuntu"
      private_key  = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_instance" "RancherHost2" {
  instance_type = "${var.instance_type}"
  ami = "${var.ec2_ami}"
  tags {
    Name = "Rancher Host 2"
  }
  

  key_name = "${var.aws_key_name_id}"
  vpc_security_group_ids = ["${var.security_group_rancher_host_id}"]
  subnet_id = "${var.subnet_id}"
  
  # TODO: get variables from rancher server config   
  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.5 ${var.rancher_host_registration_url}"
    ]

    connection {
      type         = "ssh"
      user         = "ubuntu"
      private_key  = "${file(var.private_key_path)}"
    }
  }
}