#!/bin/bash
# Try 2 times to configure with a delay of 1 minute
COUNT=0
MAXRETRY=15
RETRYDELAY=60

while [ $COUNT -lt $MAXRETRY ]; do
# terraform apply -var-file=envs/test/terraform.tfvars -target=module. envs/test 2>/dev/null
docker run -it --rm -v $PWD:/usr/terransible --env-file private/env.list  jrsalgado/terraform:latest apply -auto-approve -var-file=envs/test/terraform.tfvars -target=module.rancher envs/test
if [ $? -gt 0 ]; then
    echo "Retry script in "
    COUNT=$[$COUNT+1]
    if [ $COUNT -eq $MAXRETRY ]; then
        exit 2
    fi
    sleep $RETRYDELAY
else
    exit 0
fi

done
exit
