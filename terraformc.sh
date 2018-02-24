#/bin/bash

# expand alias
shopt -s expand_aliases

# terraform commands
TC1=$1
TC2=$2
TC3=$3
TC4=$4

alias terraform="docker run -it --rm --env-file private/env.list -v $PWD:/usr/terransible jrsalgado/terraform:latest"

terraform $TC1 $TC2 $TC3 $TC4
