#!/usr/bin/env bash

# Setup some specifics config for bots

# NOTE:
#   - Is mandatory to create a config file
#   - You can use `conf/bots-config.js.example` as a template
#   - For more references you can check:
# https://dutchx.readthedocs.io/en/latest/bots-market-making.html#how-to-run-the-bots
BOTS_CONF_DIR=conf
BOTS_CONF_FILE_NAME=bots-conf.js
BOTS_CONF_FILE="$BOTS_CONF_DIR/$BOTS_CONF_FILE_NAME"
BOTS_CONTAINER_CONF_DIR=/usr/src/app/custom_conf

# Display the bot config file
BOTS_CONFIG_INFO="Bots config file: $BOTS_CONF_FILE"
BOTS_LOCAL_CONF_DIR="$(pwd)/$BOTS_CONF_DIR"

if [[ ! -f $BOTS_CONF_FILE ]]; then
  echo "Bots config file doesn't exist. Update the BOTS_CONF_FILE_NAME or create a new configuration file based in 'conf/bots-conf.js.example'"
  echo "Please refer to https://dutchx.readthedocs.io/en/latest/bots-market-making.html#how-to-run-the-bots"
  exit -1
fi

# For PRO, please use fixed version
#   https://hub.docker.com/r/gnosispm/dx-services/tags/
DX_SERVICE_VERSION=${DX_SERVICE_VERSION:-stable}

# Extra config for the bots
read -r -d '' DOCKER_PARAMS_BOTS << EOM
 --mount type=bind,source=$BOTS_LOCAL_CONF_DIR,destination=$BOTS_CONTAINER_CONF_DIR
  -e CONFIG_FILE=$BOTS_CONTAINER_CONF_DIR/$BOTS_CONF_FILE_NAME
EOM

# Use base CLI
source util/base.sh
