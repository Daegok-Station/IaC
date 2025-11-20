module "Service_VPC" {
  source = "./Service VPC"
}

module "Jenkins_VPC" {
  source = "./Jenkins VPC"
}

module "ec2" {
  source = "./ec2"

  bastion_subnet_id = module.Jenkins_VPC.bastion_subnet_id
  jenkins_subnet_id = module.Jenkins_VPC.jenkins_subnet_id

  bastion_sg_id = module.security_groups.bastion_sg_id
  jenkins_sg_id = module.security_groups.jenkins_sg_id

  Jenkins_VPC_id = module.Jenkins_VPC.Jenkins_VPC_id
  internet_gateway_Jenkins_id = module.Jenkins_VPC.internet_gateway_Jenkins_id

  Service_VPC_id = module.Service_VPC.Service_VPC_id

  public_route_table_id  = module.Jenkins_VPC.public_route_table_id
  private_route_table_id = module.Jenkins_VPC.private_route_table_id
}
