#!/bin/bash

cd /home/ec2-user/chatty-backend
sudo rm -rf env-file.zip
sudo rm -rf .env
sudo rm -rf .env.staging
aws s3 sync s3://edward-chattyapp-env-files/backend/staging .
unzip env-file.zip
sudo cp .env.staging .env
sudo pm2 delete all
sudo npm install
