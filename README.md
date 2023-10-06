# aws-basic
AWS ECR ECS deploy test

https://blog.devgenius.io/how-to-deploy-django-application-on-aws-using-ecs-and-ecr-aab9ab003a85


django-admin startproject bpbtest .
python manage.py startapp bot

## Run locally - don
python manage.py runserver
http://localhost:8000

### Adding secrets:
Create .env file with DJANGO_SECRET_KEY
load_donenv() in settings.py
put into settings.py to SECRET_KEY=os.getenv('DJANGO_SECRET_KEY')


## Run in container - done
create Dockerfile
docker build -t bpbtest-image:v1 . 
docker run -p 127.0.0.1:80:8080/tcp bpbtest-image:v1
http://localhost/

### Adding secrets:
Works like in local, as .env file is copied into the image by COPY . .
Could be, potentially, docker-ignored, but for now we are fine with it...

## ---- Need also variant to run in GitHub for tests ----

## Run in AWS
Create .github/workflows/aws.yml
Create ECR repo
Create ECS Cluster
Create ECS Task Definition
Create ECS Service
Export JSON definition of Task Definition into .github/workflows/task-definition.json

### Adding secrets:


Create param in parameter store
in IAM add to ecsTaskExecutionRole SystemsManager, and allow GetParameter, GetParametersByPath, GetParameters


Database
Create: PostgreSQL + NOT! Easy Create
Public
Try to connect with PyCharm
put DB connection for Postgres to settings
Crete secrets for DB in Parameter Store
Update Container env vars in Task definition
Download JSON
Commit - Push