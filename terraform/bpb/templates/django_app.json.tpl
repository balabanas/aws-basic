[
  {
    "name": "django-app",
    "image": "${docker_image_url_django}",
    "essential": true,
    "cpu": 2,
    "memory": 256,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": [
        "/bin/sh", "-c",
        "python manage.py migrate && gunicorn -w 3 -b :8000 bpbtest.wsgi:application"],
    "environment": [
      {
    "name": "DB_NAME",
    "value": "${rds_db_name}"
  },
  {
    "name": "DB_USER",
    "value": "${rds_username}"
  },
  {
    "name": "DB_PASSWORD",
    "value": "${rds_password}"
  },
  {
    "name": "DB_HOST",
    "value": "${rds_hostname}"
  },
  {
    "name": "DB_PORT",
    "value": "5432"
  },
  {
    "name": "ALLOWED_HOSTS",
    "value": "${domain_name}"
  },
  {
    "name": "USE_S3",
    "value": "${use_s3}"
  },
  {
    "name": "AWS_S3_BUCKET_NAME",
    "value": "${s3_files_bucket_name}"
  },
  {
    "name": "AWS_S3_UG_ACCESS_KEY_ID",
    "value": "${s3_ug_access_key_id}"
  },
  {
    "name": "AWS_S3_UG_SECRET_ACCESS_KEY",
    "value": "${s3_ug_secret_access_key}"
  }
],
    "mountPoints": [
      {
        "sourceVolume": "static_volume",
        "containerPath": "/web/staticfiles"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/django-app",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "django-app-log-stream"
      }
    }
  },


  {
    "name": "nginx",
    "image": "${docker_image_url_nginx}",
    "essential": true,
    "cpu": 2,
    "memory": 128,
    "links": ["django-app"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "static_volume",
        "containerPath": "/web/staticfiles",
        "readOnly": true
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nginx",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "nginx-log-stream"
      }
    }
  }
]