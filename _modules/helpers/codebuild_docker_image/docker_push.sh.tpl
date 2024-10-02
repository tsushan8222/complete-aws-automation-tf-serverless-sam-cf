#!/bin/bash

docker build -t ${image_name} .

docker tag ${image_name}:latest ${repository_url}:latest

aws ecr get-login-password --region ${region} --profile ${profile} | docker login --username AWS --password-stdin  ${account_no}.dkr.ecr.${region}.amazonaws.com

docker push ${repository_url}:latest