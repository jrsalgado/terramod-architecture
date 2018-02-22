
module "network" {
   source           = "../../modules/network"

   aws_profile      = "${var.aws_profile}"
   aws_region       = "${var.aws_region}"
   key_name         = "${var.key_name}"
   public_key_path  = "${var.public_key_path}"
}

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