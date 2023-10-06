aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 455385653807.dkr.ecr.eu-north-1.amazonaws.com

docker build -t 455385653807.dkr.ecr.eu-north-1.amazonaws.com/bpb:latest .
docker push 455385653807.dkr.ecr.eu-north-1.amazonaws.com/bpb:latest

docker build -t 455385653807.dkr.ecr.eu-north-1.amazonaws.com/nginx:latest ./nginx
docker push 455385653807.dkr.ecr.eu-north-1.amazonaws.com/nginx:latest

python deploy/update-ecs.py --cluster=production-cluster --service=production-service