#!/usr/bin/env bash

# Basic usage
#   CLI:
#       duxchx-rinkeby help
#   BOTS:
#       bots/bots-rinkeby
#   CLAIM:
#       claim/claim-rinkeby

# Enable debug
# set -x

# Config
NETWORK=${NETWORK:-rinkeby}
ETHEREUM_RPC_URL="https://${NETWORK}.infura.io"
DX_SERVICE_VERSION=staging # Check: https://hub.docker.com/r/gnosispm/dx-services/tags/
SHOW_COLORS=true
DEBUG_MESSAGES=DEBUG=ERROR-*,WARN-*,INFO-*
ENVIRONMENT=pro  # local, pre, pro

# IMPORTANT:
#   - Override the MNEMONIC variable in a uncommited file 'local.conf'
#     Use 'local.conf.example' as an example
#
#   - Alternative, if there's no 'local.conf', you can also provide MNEMONIC as
#     a environment variable. i.e
#       MNEMONIC="any other mnemonic" cli help
#
#   - The DOCKER_PARAMS_LOCAL can be optionally overrided in local.conf to allow
#     to add any arbritraty info
MNEMONIC="super secret thing that nobody should know"
DOCKER_PARAMS_LOCAL=""

# IMPORTANT:
#   - This config changes by network, so review it's value in:
#     - network-kovan.conf
#     - network-rinkeby.conf
#     - network-mainnet.conf
#   - The following variables will be just the default, and will be overrided by
#     the network config files decribed iin the previous point
#

# Get LOCAL conf and NETWORK conf
LOCAL_CONF="conf/local.conf"
NETWOR_CONF="conf/network-$NETWORK.conf"
[ -f "$LOCAL_CONF" ] && source "$LOCAL_CONF" && echo "INFO: Load $LOCAL_CONF" || echo "WARN: $LOCAL_CONF file wasn't found. Using default config"
[ -f "$NETWOR_CONF" ] && source "$NETWOR_CONF" && echo "INFO: Load $NETWOR_CONF" || echo "WARN: $NETWOR_CONF file wasn't found. Using default config"

# Docker image used:
#   https://hub.docker.com/r/gnosispm/dx-services/tags/
DOCKER_IMAGE="gnosispm/dx-services:$DX_SERVICE_VERSION"

echo
echo "  *********  DutchX ($DX_SERVICE_VERSION) - $APP_NAME  *********"
echo "    Operation: $CLI_PARAMS"
echo "    Markets: $MARKETS"
echo "    Ethereum Node: $ETHEREUM_RPC_URL"
echo ""
echo "    Using:"
echo "      Local config: $LOCAL_CONF"
echo "      Network config: $NETWOR_CONF"
[ ! -z "$BOTS_CONFIG_INFO" ] && echo "      $BOTS_CONFIG_INFO"
echo ""
echo "    Learn how to configure and use the CLI:"
echo "      https://github.com/gnosis/dx-cli#get-started-with-the-cli"
echo ""
echo "    DutchX documentation:"
echo "      https://dutchx.readthedocs.io/en/latest"
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
  $DOCKER_PARAMS_LOCAL \
  $DOCKER_PARAMS_BOTS \
  $DOCKER_PARAMS_NETWORK \
  $DOCKER_IMAGE \
  $APP_COMMAND
