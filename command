aws deploy create-deployment \
    --region us-east-1 \
    --application-name chatapp-server-default-edward-app \
    --deployment-config-name CodeDeployDefault.AllAtOnce \
    --deployment-group-name chatapp-server-default-group \
    --file-exists-behavior "OVERWRITE" \
    --s3-location bucket=chatapp-server-default-edward-project-app,bundleType=zip,key=chatapp.zip
