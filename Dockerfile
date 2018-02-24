# TODO: test usage of new tools and research 
FROM hashicorp/terraform:light

# Use your own AWS AMI CREDENTIALS
# TODO: test IAM setup on AWS and best practices

# you can set this variables on run time or on build time
# use a private env.list file
# DECLARE AWS ENV vars
ENV AWS_ACCESS_KEY_ID="default_access_key"
ENV AWS_SECRET_ACCESS_KEY="default_secret_key"
ENV AWS_DEFAULT_REGION="us-west-1"

# Install python and py-pip
# Docker RUN command example. 
# RUN apk add python
# TODO: test linux pkgs installation commands 
RUN apk add --update python py-pip \
    # install aws
    && pip install awscli \
    # configure awscli with your IAM credentials
    && aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID \
    && aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY \
    && aws configure set default.region $AWS_DEFAULT_REGION
WORKDIR /usr/terransible

ENTRYPOINT ["terraform"]
