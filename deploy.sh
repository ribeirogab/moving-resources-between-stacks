#!/bin/bash
# ninja:   ./deploy.sh
STAGE=${1:-ninja}
PROJECT=$STAGE-test-lambdas-stack-2
PARAMETERS="TestLambdasEnvironmentName=${STAGE}"
BUCKET_NAME=$PROJECT-deploy-bucket
S3_CHECK=$(aws s3 ls "s3://${BUCKET_NAME}" 2>&1)
NO_BUCKET_CHECK=$(echo $S3_CHECK | grep -c 'NoSuchBucket')

if [ $NO_BUCKET_CHECK = 1 ]
then
  aws s3 mb s3://$BUCKET_NAME
fi

sam validate --template-file ./template_stack2.yml --region us-east-1

sam deploy --stack-name $PROJECT \
           --s3-bucket $BUCKET_NAME \
           --capabilities CAPABILITY_NAMED_IAM \
           --region us-east-1 \
           --fail-on-empty-changeset \
           --no-confirm-changeset \
           --parameter-overrides $PARAMETERS \
           --template-file ./template_stack2.yml

aws s3 rb s3://$BUCKET_NAME --force
