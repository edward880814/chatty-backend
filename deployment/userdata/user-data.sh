#!/bin/bash

function program_is_installed {
  local return_=1

  type $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

# Update the system and install required dependencies
sudo yum update -y
sudo yum install -y ca-certificates curl

# Check if NodeJs is installed. If not, install it manually
if [ $(program_is_installed node) == 0 ]; then
  # Download and import the NodeSource GPG key
  sudo mkdir -p /etc/pki/rpm-gpg
  sudo curl -fsSL -o nodesource.gpg https://deb.nodesource.com/gpgkey/nodesource.gpg.key
  sudo gpg --dearmor -o /etc/pki/rpm-gpg/nodesource.gpg < nodesource.gpg

  # Set the desired Node.js version (change NODE_MAJOR as needed)
  NODE_MAJOR=16

  # Download the setup script
  sudo curl -fsSL https://rpm.nodesource.com/setup_$NODE_MAJOR.x -o nodesource_setup.sh

  # Run the setup script
  sudo bash nodesource_setup.sh

  # Install Node.js
  sudo yum install -y nodejs
fi

sudo yum install ruby -y
sudo yum install wget -y
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto

if [ $(program_is_installed git) == 0 ]; then
  sudo yum install git -y
fi

if [ $(program_is_installed docker) == 0 ]; then
  sudo amazon-linux-extras install docker -y
  sudo systemctl start docker
  sudo docker run --name chatapp-redis -p 6379:6379 --restart always --detach redis
fi

if [ $(program_is_installed pm2) == 0 ]; then
  npm install -g pm2
fi

cd /home/ec2-user

git clone -b develop https://github.com/edward880814/chatty-backend.git
cd chatty-backend
npm install
aws s3 sync s3://edward-chattyapp-env-files/develop .
unzip env-file.zip
cp .env.develop .env
npm run build
npm run start
