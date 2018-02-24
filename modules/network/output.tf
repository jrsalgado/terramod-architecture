output "aws_security_group-Site1-id" {
  value = "${aws_security_group.Site1-sg.id}"
}

output "aws_security_group_rancher_host_id" {
  value = "${aws_security_group.RancherHost-sg.id}"
}

output "aws_subnet_Site1_id" {
  value = "${aws_subnet.Site1-subnet1.id}"
}

output "aws_key_name_id" {
  value = "${aws_key_pair.auth.id}"
}
