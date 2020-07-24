#configuracoes comuns a todo ambiente de homo
provider "aws" {
    region = "regiao_aws"
    version = "~> 2.27"
}

variable "awsvpc" {
  description = "VPC AWS"
  default = "vpc-ambiente-homo"
}

variable "awsaccount" {
  description = "Conta da AWS"
  default = "conta_de_homo"
}

variable "awsseggroup" {
  description = "Security group"
  default = "grupo_seguranca_homo"
}

variable "refpath" {
  description = "Composicao de caminho"
  default = "-homo"
}

data "aws_subnet" "default_private_a" {
    filter {
        name = "tag:Name"
        values = ["subnet_conta_homo_a"]
    }
}

data "aws_subnet" "default_private_b" {
    filter {
        name = "tag:Name"
        values = ["conta_subnet_homo_b"]
    }
}

data "aws_security_group" "seg_comercial_app" {
    name = "${var.awsseggroup}"
 
}

data "aws_lb" "default" {
  name = "load-balancer-homo"
}

data "aws_lb_listener" "default" {
  load_balancer_arn = "${data.aws_lb.default.arn}"
  port = 80
}


