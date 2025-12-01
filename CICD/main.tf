module "Service_VPC" {
  source = "./Service_VPC"
}

module "Jenkins_VPC" {
  source = "./Jenkins_VPC"
  Jenkins_VPC_cidr = "10.0.0.0/16"
}

module "ec2" {
  source = "./ec2"

  bastion_subnet_id = module.Jenkins_VPC.bastion_subnet_id
  jenkins_subnet_id = module.Jenkins_VPC.jenkins_subnet_id

  bastion_sg_id = module.ec2.bastion_sg_id
  jenkins_sg_id = module.ec2.jenkins_sg_id
  alb_sg_id = module.alb.alb_sg_id

  Jenkins_VPC_id = module.Jenkins_VPC.Jenkins_VPC_id
  internet_gateway_Jenkins_id = module.Jenkins_VPC.internet_gateway_Jenkins_id

  Service_VPC_id = module.Service_VPC.Service_VPC_id

  public_route_table_id  = module.Jenkins_VPC.public_route_table_id
  private_route_table_id = module.Jenkins_VPC.private_route_table_id

  bastion_key_name = "test_key"
  jenkins_key_name = "test_key"

  Jenkins_VPC_cidr = module.Jenkins_VPC.Jenkins_VPC_cidr
  Service_VPC_cidr = module.Service_VPC.Service_VPC_cidr
}


module "ecs" {
  source = "./ecs"

  Service_VPC_id = module.Service_VPC.Service_VPC_id
  private_subnet_id_01 = module.Service_VPC.private_subnet_id_01
  app_alb_arn            = module.alb.app_alb_arn
  ecr_repository_url = module.ecr.ecr_repository_url
  blue_listener_arn = module.alb.blue_listener_arn
  green_listener_arn = module.alb.green_listener_arn
  blue_tg_arn  = module.alb.blue_tg_arn
  green_tg_arn = module.alb.green_tg_arn
  ecs_service_role_arn        = module.ec2.ecs_service_role_arn
  ecs_task_execution_role_arn = module.ec2.ecs_task_execution_role_arn
}


module "alb" {
  source = "./alb"

  public_subnet_id_01 = module.Service_VPC.public_subnet_id_01
  public_subnet_id_02 = module.Service_VPC.public_subnet_id_02
  Service_VPC_id      = module.Service_VPC.Service_VPC_id
  jenkins_sg_id = module.ec2.jenkins_sg_id
  Service_VPC_cidr = module.Service_VPC.Service_VPC_cidr
}


module "s3" {
  source = "./s3"

  codedeploy_role_arn = module.ec2.codedeploy_role_arn
  blue_listener_arn = module.alb.blue_listener_arn
  green_listener_arn = module.alb.green_listener_arn

}

module "ecr" {
  source = "./ecr"
  ecr_name = "spring-petclinic"
}
