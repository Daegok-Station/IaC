#################################################################################
################################### ec2 Role ####################################
#################################################################################

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

########################### EC2용 Instance Profile ##############################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_role"                    # Role과 이름 맞춤
  role = aws_iam_role.ec2_role.name    # 정확한 Role 참조
}

#################################################################################
########################## ec2 Role 정책 생성 및 연결 #############################
#################################################################################

############################# ALB 정책 생성 / 연결 ################################

resource "aws_iam_policy" "alb_policy" {
  name = "ALB"
  policy = var.alb_policy_json
}

resource "aws_iam_role_policy_attachment" "ALB_attach" {
  role = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}

############################## 계속 추가해야 함 ##################################
