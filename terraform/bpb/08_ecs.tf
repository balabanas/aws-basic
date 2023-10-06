resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.ecs_cluster_name}-cluster"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
#  key_name                    = aws_key_pair.production.key_name  #introducing bastion
  key_name = aws_key_pair.bastion_key_pair.key_name
  associate_public_ip_address = false  # need this? in private network (was true)
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config\necho ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config"
}

data "template_file" "app" {
  template = file("templates/django_app.json.tpl")

  vars = {
    docker_image_url_django = var.docker_image_url_django
    docker_image_url_nginx  = var.docker_image_url_nginx
    region                  = var.region
    rds_db_name             = var.rds_db_name
    rds_username            = var.rds_username
    rds_password            = data.aws_ssm_parameter.rds_password.value  // var.rds_password
    rds_hostname            = aws_db_instance.production.address
    domain_name             = var.domain_name
    use_s3                  = var.use_s3
    s3_files_bucket_name    = var.s3_files_bucket_name
    s3_ug_access_key_id     = data.aws_ssm_parameter.s3_ug_access_key_id.value
    s3_ug_secret_access_key = data.aws_ssm_parameter.s3_ug_secret_access_key.value
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "django-app"
  container_definitions = data.template_file.app.rendered
  depends_on            = [aws_db_instance.production]
#  execution_role_arn = "arn:aws:iam::455385653807:role/ecsTaskExecutionRole"

  volume {
    name = "static_volume"
    #    host_path = "/web/staticfiles/"
  }
}

resource "aws_ecs_service" "production" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-https-listener, aws_iam_role_policy.ecs-service-role-policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    #    container_name   = "django-app"
    #    container_port   = 8000
    container_name   = "nginx"
    container_port   = 80
  }
}