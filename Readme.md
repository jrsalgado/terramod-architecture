# use a terramod architecture
# https://www.slideshare.net/opencredo/hashidays-london-2017-evolving-your-infrastructure-with-terraform-by-nicki-watt

#docker run -it --rm -v $PWD:/usr/terransible --env-file private/env.list  jrsalgado/terraform:latest destroy -var-file=envs/test/terraform.tfvars envs/test

#docker run -it --rm --entrypoint="" --env-file private/env.list  jrsalgado/terraform:latest /bin/sh

# run just network and rancher instance
```bash
docker run -it --rm -v $PWD:/usr/terransible --env-file private/env.list  jrsalgado/terraform:latest apply -var-file=envs/test/terraform.tfvars -target=module.network -target=module.instances envs/test
```
then
# run rancher setings and rancher host
```bash
docker run -it --rm -v $PWD:/usr/terransible --env-file private/env.list  jrsalgado/terraform:latest apply -var-file=envs/test/terraform.tfvars -target=module.rancher envs/test
```

# Deployment steps
## Create network and rancher server instance
```
terraform apply -var-file=envs/test/terraform.tfvars -target=module.network -target=module.instances envs/test
```

## Run Rancher environment configurations
# note: run until Rancher server is ready
```
terraform apply -var-file=envs/test/terraform.tfvars -target=module.rancher envs/test
```

## Create Rancher Host and register in rancher host
```
terraform apply -var-file=envs/test/terraform.tfvars -target=module.rancher_hosts envs/test
```
# run and wait
```
# boostrap network and rancher server
docker run -it --rm -v $PWD:/usr/terransible --env-file private/env.list  jrsalgado/terraform:latest apply -auto-approve -var-file=envs/test/terraform.tfvars -target=module.network envs/test

# set rancher hosts and app stack
./rancherConfScheduler.sh
```
