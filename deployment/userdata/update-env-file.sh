#!/bin/bash

aws s3 sync s3://edward-chattyapp-env-files/backend/staging .
unzip env-file.zip
cp .env.staging .env
rm .env.staging
# doesn't work on WSL
# sed -i -e "s|\(^REDIS_HOST=\).*|REDIS_HOST=redis://$ELASTICACHE_ENDPOINT:6379|g" .env
sed -i -E "s|^REDIS_HOST = .+|REDIS_HOST = redis://$ELASTICACHE_ENDPOINT:6379|g" .env
rm -rf env-file.zip
cp .env .env.staging
zip env-file.zip .env.staging
aws --region us-east-1 s3 cp env-file.zip s3://edward-chattyapp-env-files/backend/staging/
rm -rf .env*
rm -rf env-file.zip
