#!/usr/bin/env bash

# Basic usage
#
#   cli help
#   NETWORK=mainnet cli help

# Config
NETWORK=${NETWORK:-rinkeby}
ETHEREUM_RPC_URL="https://${NETWORK}.infura.io"
DX_SERVICE_VERSION=staging # Check: https://hub.docker.com/r/gnosispm/dx-services/tags/
SHOW_COLORS=true
DEBUG_MESSAGES=DEBUG=ERROR-*,WARN-*,INFO-*,DEBUG-dx-service:services:*,DEBUG-dx-service:repositories:PriceRepo*
ENVIRONMENT=pro  # local, pre, pro
#DEBUG_MESSAGES=DEBUG=ERROR-*,WARN-*,INFO-*,DEBUG-*
#DEBUG_MESSAGES=DEBUG=ERROR-*,WARN-*,INFO-*

# IMPORTANT:
#   - Override the MNEMONIC variable in a uncommited file 'local.conf'
#     Use 'local.conf.example' as an example
#
#   - Alternative, if there's no 'local.conf', you can also provide MNEMONIC as
#     a environment variable. i.e
#       MNEMONIC="any other mnemonic" cli help
MNEMONIC="super secret thing that nobody should know"


# IMPORTANT:
#   - This config changes by network, so review it's value in:
#     - network-ovan.conf
#     - network-rinkeby.conf
#     - network-mainnet.conf
#   - The following variables will be just the default, and will be overrided by
#     the network config files decribed iin the previous point
#

# Get the params
CLI_PARAMS=${@:--h}

DOCKER_IMAGE="gnosispm/dx-services:$DX_SERVICE_VERSION"
APP_COMMAND="yarn cli $CLI_PARAMS"
NETWOR_CONF="network-$NETWORK.conf"

[ -f local.conf ] && source local.conf || echo "WARN: local.conf file wasn't found. Using default config"
[ -f "$NETWOR_CONF" ] && source "$NETWOR_CONF" || echo "WARN: $NETWOR_CONF file wasn't found. Using default config"

echo
echo "  *********  DutchX CLI - $DX_SERVICE_VERSION  *********"
echo "    Operation: $CLI_PARAMS"
echo "    Markets: $MARKETS"
echo "    Ethereum Node: $ETHEREUM_RPC_URL"
echo ""
echo "    Using:"
echo "      Local config: local.conf"
echo "      Network config: $NETWOR_CONF"
echo "  *********************************"
echo
echo "[cli] Getting docker image: $DOCKER_IMAGE..."
docker pull $DOCKER_IMAGE

echo
docker run \
  -p 8081:8081 \
  -e DEBUG=$DEBUG_MESSAGES \
  -e DEBUG_COLORS=$SHOW_COLORS \
  -e MNEMONIC="$MNEMONIC" \
  -e NETWORK="$NETWORK" \
  -e ETHEREUM_RPC_URL=$ETHEREUM_RPC_URL \
  -e NODE_ENV=$ENVIRONMENT \
  -e MARKETS=$MARKETS \
  $DOCKER_PARAMS_NETWORK \
  $DOCKER_IMAGE \
  $APP_COMMAND
