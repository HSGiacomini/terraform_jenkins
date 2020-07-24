#configuracoes comuns a todo ambiente de dev
provider "aws" {
    region = "regiao_aws"
    version = "~> 2.27"
}

variable "awsvpc" {
  description = "VPC AWS"
  default = "vpc-ambiente-dev"
}

variable "awsaccount" {
  description = "Conta da AWS"
  default = "conta_de_dev"
}

variable "awsseggroup" {
  description = "Security group"
  default = "grupo_seguranca_dev"
}

variable "refpath" {
  description = "Composicao de caminho"
  default = "-dev"
}

data "aws_subnet" "default_private_a" {
    filter {
        name = "tag:Name"
        values = ["subnet_conta_dev_a"]
    }
}

data "aws_subnet" "default_private_b" {
    filter {
        name = "tag:Name"
        values = ["conta_subnet_dev_b"]
    }
}

data "aws_security_group" "default" {
    name = "${var.awsseggroup}"
 
}

data "aws_lb" "default" {
  name = "load-balancer-dev"
}

data "aws_lb_listener" "default" {
  load_balancer_arn = "${data.aws_lb.default.arn}"
  port = 80
}


