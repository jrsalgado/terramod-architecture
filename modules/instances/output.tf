output "instance_public_ip" {
  value = "${aws_instance.rancherServer.public_ip}"
}
