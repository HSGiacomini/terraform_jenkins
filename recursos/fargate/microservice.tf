## 1 - Repository ##
resource "aws_ecr_repository" "api-ecrrepository" {
  name = var.api-repositoryname
  tags = {
    ProjectName = "${var.projectname}"
  }
}

## 2 - log do cloudwatch ##
resource "aws_cloudwatch_log_group" "api-cloudwatchloggroup" {
  name = "/ecs/${var.api-taskname}"
  retention_in_days = 3

  tags = {
    ProjectName = "${var.projectname}"
  }
}

## 3 - definição de task ##
resource "aws_ecs_task_definition" "api-taskname" {
  family = var.api-taskname
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  execution_role_arn = "arn:aws:iam::${var.awsaccount}:role/ecsTaskExecutionRole"
  container_definitions = <<-DEFINITION
    [
      {
        "name" : "${var.api-containername}",
        "image"  : "${var.awsaccount}.dkr.ecr.${var.awsregion}.amazonaws.com/${aws_ecr_repository.api-ecrrepository.name}",

        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : 80,
            "hostPort" : 80
          }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/${var.api-taskname}",
            "awslogs-region": "${var.awsregion}",
            "awslogs-stream-prefix": "ecs"
          }
        }
      }
    ]

  DEFINITION
  cpu = "${var.container-cpu}"
  memory = "${var.container-mem}"
  tags = {
    ProjectName = "${var.projectname}"
  }
}

## 4 - target load balance ##
resource "aws_lb_target_group" "api-targetgroup" {
  name        = var.api-tg-name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.awsvpc

  health_check {
    interval            = 300
    path                = "${var.healthpath}"  
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = 200
  }
  tags = {
    ProjectName = "${var.projectname}"
  }

  depends_on = [ data.aws_lb.comercial ]
}

## 5 - listener ##
resource "aws_lb_listener_rule" "api-listenerrule" {
  listener_arn = data.aws_lb_listener.default.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api-targetgroup.arn
  }

  condition {
    path_pattern {
        values = ["${var.api-pathpattern}"]
    }
  }
  
}

## 6 - servico ##
resource "aws_ecs_service" "api-ecsservice" {
  name            = var.api-srv-name
  cluster         = var.clustername
  task_definition = "${aws_ecs_task_definition.api-taskname.family}:${max("${aws_ecs_task_definition.api-taskname.revision}", "${aws_ecs_task_definition.api-taskname.revision}")}"
  desired_count   = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = ["${data.aws_subnet.default_private_${var.awsregion}c.id}"]
    security_groups = ["${data.aws_security_group.default.id}"]
    assign_public_ip = false
    }
  load_balancer {
    target_group_arn = aws_lb_target_group.api-targetgroup.arn
    container_name   = var.api-containername
    container_port   = 80
  }
 

}