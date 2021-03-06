# first apply -target = network -target = network
module "network" {
   source           = "../../modules/network"

   aws_profile      = "${var.aws_profile}"
   aws_region       = "${var.aws_region}"
   key_name         = "${var.key_name}"
   public_key_path  = "${var.public_key_path}"
   domain_name      = "${var.domain_name}"
   delegation_set       = "${var.delegation_set}"
   instance_public_ip   = "${module.instances.instance_public_ip}"
   route53_zone_id      =   "${var.route53_zone_id}"
}

# Rancher servers
module "instances" {
   source              = "../../modules/instances"

   aws_profile         = "${var.aws_profile}"
   aws_region          = "${var.aws_region}"
   ec2_ami             = "${var.ec2_ami}"
   instance_type       = "${var.instance_type}"
   security_group_id   = "${module.network.aws_security_group-Site1-id}"
   subnet_id           = "${module.network.aws_subnet_Site1_id}"
   aws_key_name_id     = "${module.network.aws_key_name_id}"
   private_key_path    = "${var.private_key_path}"
 }


# second apply -target=module.rancher
# Rancher Env configuration
module "rancher" {
  source    = "../../modules/rancher"

  # Rancher settings 
  domain_name    = "${var.domain_name}"
  api_url        = "http://test.${var.domain_name}.com:8080"
   
  # Rancher Host, own module?
  instance_type      = "${var.instance_type}"
  ec2_ami            = "${var.ec2_ami}"
  aws_key_name_id    = "${module.network.aws_key_name_id}"
  security_group_rancher_host_id = "${module.network.aws_security_group_rancher_host_id}"
  subnet_id          = "${module.network.aws_subnet_Site1_id}"
  private_key_path   = "${var.private_key_path}"
 }

module "rancher_hosts" {
  source             = "../../modules/rancher_hosts"

  instance_type      = "${var.instance_type}"
  ec2_ami            = "${var.ec2_ami}"
  aws_key_name_id    = "${module.network.aws_key_name_id}"
  security_group_rancher_host_id = "${module.network.aws_security_group_rancher_host_id}"
  subnet_id          = "${module.network.aws_subnet_Site1_id}"
  private_key_path   = "${var.private_key_path}"
  rancher_host_registration_url = "${module.rancher.rancher_host_registration_url}"
}
