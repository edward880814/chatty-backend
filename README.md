[![CircleCI](https://dl.circleci.com/status-badge/img/gh/edward880814/chatty-backend/tree/develop.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/edward880814/chatty-backend/tree/develop)
[![codecov](https://codecov.io/gh/edward880814/chatty-backend/graph/badge.svg?token=YQ8AT8M4H1)](https://codecov.io/gh/edward880814/chatty-backend)

# Chatty Backend

Chatty backend is a real-time social network application developed using [node.js](https://nodejs.org/en/), [typescript](https://www.typescriptlang.org/), [redis](https://redis.io/download/) and [mongodb](https://www.mongodb.com/docs/manual/administration/install-community/).

## Features

1. Signup and signin authentication
2. Forgot password and reset password
3. Change password when logged in
4. Create, read, update and delete posts
5. Post reactions
6. Comments
7. Followers, following, block and unblock
8. Private chat messaging with text, images, gifs, and reactions
9. Image upload
10. In-app notification and email notification

## Main tools

- Node.js
- Typescript
- MongoDB
- Mongoose
- Redis
- Express
- Bull
- PM2
- AWS
- Terraform
- Nodemailer
- Sendgrid mail
- Cloudinary
- Jest
- Lodash
- Socket.io

## Requirements

- Node 16.x or higher
- Redis ([https://redis.io/download/](https://redis.io/download/))
- MongoDB ([https://www.mongodb.com/docs/manual/administration/install-community/](https://www.mongodb.com/docs/manual/administration/install-community/))
- Typescript
- API key, secret and cloud name from cloudinary [https://cloudinary.com/](https://cloudinary.com/)
- Local email sender and password [https://ethereal.email/](https://ethereal.email/)

Need to copy the contents of `.env.development.example`, add to `.env` file and update with the necessary valid information.

Make sure mongodb and redis are both running on local machine.

## Unit tests

- The command `npm run test` can execute the unit tests added to the features controllers.

## API Endpoints

- The actual endpoints for the application can be found inside the folder named `endpoints` [https://github.com/edward880814/chatty-backend/tree/develop/endpoints]
- The endpoint files all have a `.http` extension.
- To use this files to make api calls, install the extension called [rest client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) on vscode.
- Update the endpoints http files before using.
- The files inside the endpoints folder contains APIs for
  - Authentication
  - Chat
  - Comments
  - Followers, following, block and unblock
  - Health
  - Images
  - Notification
  - Posts
  - Reactions
  - User

## View Data

- The contents can be viewed by redis cache by using a tool called [redis-commander](https://www.npmjs.com/package/redis-commander).
- Download mongodb compass to view data. [https://www.mongodb.com/try/download/compass](https://www.mongodb.com/try/download/compass).

# AWS Setup

- Create an account on AWS.
- Download and install aws cli.
- On AWS, create an IAM user, it will generate a key and secret.
- Use aws configure command to add iam secret and key to local machine.
- To deploy the backend server on AWS, it is required you have a domain to use.
- With that domain, manually create a route53 hosted zone on AWS.
- Copy the hosted zone NS properties and add to the nameservers section of your domain on the dashboard of your domain name provider. e.g: godaddy, namecheap etc.

## AWS Resources Used

- VPC
- Subnets
- Internet gateways
- Route tables
- Elastic ips
- Nat gateways
- Security groups
- ALB target groups
- Route53
- AWS Certificate Manager
- Application load balancers
- IAM roles
- Elasticache
- EC2 launch config
- EC2 instances
- Autoscaling group
- S3
- Code deploy
- Cloudwatch

## AWS Infrastructure Setup with Terraform

- Install [terraform](https://www.terraform.io/downloads)
- Update the `variables.tf` file with the correct data. Update the properties with comments.
- To store your terraform remote state on AWS, first create a unique S3 bucket with a sub-folder name called `develop`.
- Add that S3 bucket name to `main.tf` file. Also add your region to the file.
- Create a keyPair on AWS. Keep the key safe on your local machine and add the name of the keyPair to `ec2_launch_config.tf` and `bastion_hosts.tf` files.
- Before running the terraform apply command to your resources, you need to
  - create a new s3 bucket to store env files
  - inside the created s3 bucket, add a sub-folder called backend and inside the backend folder another sub-folder called develop. Bucket path should be something like `<your-s3-bucket>/backend/develop`
  - in your project, create a `.env.develop` file. Add the contents of `.env` to the new file.
  - the contents of `.env.develop` needs to be properties that will be used when deployed
    - `DATABASE_URL` should be an actual mongodb url. You can create an account on [mongodb atlas](https://www.mongodb.com/atlas/database) and create a new database.
    - `NODE_ENV` can be set to production
    - `CLIENT_URL` can be set to the frontend application local url or actual domain
    - `API_URL` should be `https://api.dev.<your-backend-domain>` that you specified inside your terraform `variables.tf` file.
    - `SENDGRID_API_KEY` and `SENDGRID_SENDER` should be created from sendgrid dashboard. Create an account.
  - after updating the `.env.develop` file, you can zip it and upload it to the new s3 bucket you created to store env files. Upload using aws cli
    - `zip env-file.zip .env.develop`. The file must be called `env-file.zip`.
    - `aws --region <your-region> s3 cp env-file.zip s3://<your-s3-bucket>/backend/develop/`
- Go into the `user-data.sh` and `update-env-file.sh` files and update.
- Once the `env-file.zip` has been added to your s3 bucket, you can execute inside the `deployment` folder, the commands:
  - `terraform init`
  - `terraform validate`
  - `terraform fmt`
  - `terraform plan`
  - `terraform apply -auto-approve`
- It will take sometime to create the resources. If everything works well, you should be able to access the backend dev api endpoints.
- To destroy all created resources, run
  - `terraform destroy`

## Setup CI/CD Pipeline with CircleCI

- Create an account on circleci.
- Signup or login with the github account where you stored your code.
- Setup project.
- Add the environment variables
- For `CODECOV_TOKEN`, visit [CodeCov](https://about.codecov.io/) and signup or login with the same account where you have your project stored.
  - Once you login and setup your project, you will receive a token. Add that token to circleci.
- For `CODE_DEPLOY_UPDATE`, the default value is false. That is the first time you are setting up your pipeline and infrastructure. Once everything is setup and running, if you need to update your backend code, then you can change the property to true.
- `SLACK_ACCESS_TOKEN` and `SLACK_DEFAULT_CHANNEL` can be obtained by following this [documentation](https://github.com/CircleCI-Public/slack-orb/wiki/Setup).
