############CREATING A ECS CLUSTER#############

resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.app_name}-${var.app_environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx",
      "image"     : "nginx:1.23.1",
      "cpu"       : 256,
      "memory"    : 512,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.app_environment
  }
}

resource "aws_ecs_service" "service" {
  name             = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = "${aws_ecs_task_definition.task.family}:${max(aws_ecs_task_definition.task.revision)}"
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id,
                        aws_security_group.load_balancer_security_group.id]
    subnets          = aws_subnet.subnet.*.id
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
    load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-${var.app_environment}-container"
    container_port   = 8080
  }
  depends_on = [aws_lb_listener.listener]
}
