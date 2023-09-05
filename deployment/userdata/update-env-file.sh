#!/bin/bash

aws s3 sync s3://edward-chattyapp-env-files/develop .
unzip env-file.zip
cp .env.develop .env
rm .env.develop
# doesn't work on WSL
# sed -i -e "s|\(^REDIS_HOST=\).*|REDIS_HOST=redis://$ELASTICACHE_ENDPOINT:6379|g" .env
sed -i -E "s|^REDIS_HOST = .+|REDIS_HOST = redis://$ELASTICACHE_ENDPOINT:6379|g" .env
rm -rf env-file.zip
cp .env .env.develop
zip env-file.zip .env.develop
aws --region us-east-1 s3 cp env-file.zip s3://edward-chattyapp-env-files/develop/
rm -rf .env*
rm -rf env-file.zip
