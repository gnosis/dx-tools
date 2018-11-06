#!/usr/bin/env bash

# Setup some specifics config for bots

# BuyBot: Check time
# TODO: Move this to bot-conf.js?
BUY_LIQUIDITY_BOT_CHECK_TIME_MS=10000

# NOTE:
#   - All the config is in conf/bots.js
#   - The bots have some default config, but it can be overrided using that file
BOTS_CONF_DIR=conf
BOTS_CONF_FILE_NAME=bots-conf.js
BOTS_CONF_FILE="$BOTS_CONF_DIR/$BOTS_CONF_FILE_NAME"
BOTS_CONTAINER_CONF_DIR=/usr/src/app/custom_conf

# Displau the bot config file
BOTS_CONFIG_INFO="Bots config file: $BOTS_CONF_FILE"
BOTS_LOCAL_CONF_DIR="$(pwd)/$BOTS_CONF_DIR"

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
