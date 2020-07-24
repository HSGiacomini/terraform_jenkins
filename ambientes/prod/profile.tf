#configuracoes comuns a todo ambiente de prod
provider "aws" {
    region = "regiao_aws"
    version = "~> 2.27"
}

variable "awsvpc" {
  description = "VPC AWS"
  default = "vpc-ambiente-prod"
}

variable "awsaccount" {
  description = "Conta da AWS"
  default = "conta_de_prod"
}

variable "awsseggroup" {
  description = "Security group"
  default = "grupo_seguranca_prod"
}

variable "refpath" {
  description = "Composicao de caminho"
  default = "-prod"
}

data "aws_subnet" "default_private_a" {
    filter {
        name = "tag:Name"
        values = ["subnet_conta_prod_a"]
    }
}

data "aws_subnet" "default_private_b" {
    filter {
        name = "tag:Name"
        values = ["conta_subnet_prod_b"]
    }
}

data "aws_security_group" "seg_comercial_app" {
    name = "${var.awsseggroup}"
 
}

data "aws_lb" "default" {
  name = "load-balancer-prod"
}

data "aws_lb_listener" "default" {
  load_balancer_arn = "${data.aws_lb.default.arn}"
  port              = 80
}


