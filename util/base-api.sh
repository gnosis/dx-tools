#!/usr/bin/env bash

# Setup some specifics config for api

# # NOTE:
# #   - Is mandatory to create a config file
# #   - You can use `conf/api-config.js.example` as a template
# #   - For more references you can check:
# # https://dutchx.readthedocs.io/en/latest
# API_CONF_DIR=conf
# API_CONF_FILE_NAME=api-conf.js
# API_CONF_FILE="$API_CONF_DIR/$API_CONF_FILE_NAME"
# API_CONTAINER_CONF_DIR=/usr/src/app/custom_conf

# # Display the bot config file
# API_CONFIG_INFO="Api config file: $API_CONF_FILE"
# API_LOCAL_CONF_DIR="$(pwd)/$API_CONF_DIR"

# if [[ ! -f $API_CONF_FILE ]]; then
#   echo "Api config file doesn't exist. Update the API_CONF_FILE_NAME or create a new configuration file based in 'conf/api-conf.js.example'"
#   echo "Please refer to https://dutchx.readthedocs.io/en/latest"
#   exit -1
# fi

# # For PRO, please use fixed version
# #   https://hub.docker.com/r/gnosispm/dx-services/tags/
# DX_SERVICE_VERSION=${DX_SERVICE_VERSION:-stable}

# # Extra config for the api
# read -r -d '' DOCKER_PARAMS_API << EOM
#  --mount type=bind,source=$API_LOCAL_CONF_DIR,destination=$API_CONTAINER_CONF_DIR
#   -e CONFIG_FILE=$API_CONTAINER_CONF_DIR/$API_CONF_FILE_NAME
# EOM

# Use base CLI
source util/base.sh
