output "instance_public_ip" {
  value = "${aws_instance.rancherServer.public_ip}"
}

output "rancher_server_public_dns" {
  value = "${aws_instance.rancherServer.public_dns}"
}