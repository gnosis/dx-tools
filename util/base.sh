#!/usr/bin/env bash

# Basic usage
#   CLI:
#       duxchx-rinkeby -h
#   BOTS:
#       bots/bots-rinkeby
#   CLAIM:
#       claim/claim-rinkeby

# Enable debug
# set -x

# Config
NETWORK=${NETWORK:-rinkeby}
ETHEREUM_RPC_URL="https://${NETWORK}.infura.io"
DX_SERVICE_VERSION=${DX_SERVICE_VERSION:-staging} # Check: https://hub.docker.com/r/gnosispm/dx-services/tags/
SHOW_COLORS=true
DEBUG_MESSAGES=DEBUG=ERROR-*,WARN-*,INFO-*
ENVIRONMENT=pro  # local, pre, pro

#   - This value is setted to a default to make optional to create a local.conf
#   - The DOCKER_PARAMS_LOCAL can be optionally overrided in local.conf to allow
#     to add any arbritraty info
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
NETWORK_CONF="conf/network-$NETWORK.conf"
[ -f "$LOCAL_CONF" ] && source "$LOCAL_CONF" || echo "WARN: $LOCAL_CONF file wasn't found. Using default config"
[ -f "$NETWORK_CONF" ] && source "$NETWORK_CONF" || echo "WARN: $NETWORK_CONF file wasn't found. Using default config"

# IMPORTANT:
#   - Override the MNEMONIC variable in a uncommited file 'local.conf'
#     Use 'local.conf.example' as an example
#
#   - Alternative, if there's no 'local.conf', you can also provide MNEMONIC as
#     a environment variable. i.e
#       MNEMONIC="any other mnemonic" cli -h
#
DEFAULT_MNEMONIC="super secret thing that nobody should know"
MNEMONIC="${MNEMONIC:-$DEFAULT_MNEMONIC}"
DEFAULT_PK="afe7bbba49336d061a0991dcc4265edc6d0efe1af6c80a848c6e8996986d0159"
PK="${PK:-$DEFAULT_PK}"

# Select account secret method.
# After loading all configuration we select the Account Secret used MNEMONIC or PK
ACCOUNT_SECRET_METHOD=MNEMONIC
ACCOUNT_SECRET_VALUE=$MNEMONIC
if [[ $PK != $DEFAULT_PK ]]; then
  ACCOUNT_SECRET_METHOD=PK
  ACCOUNT_SECRET_VALUE=$PK
fi

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
echo "      Network config: $NETWORK_CONF"
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
docker run --rm \
  -p 8081:8081 \
  -v "$(pwd)"/resources:/usr/src/app/resources \
  -e DEBUG=$DEBUG_MESSAGES \
  -e $ACCOUNT_SECRET_METHOD="$ACCOUNT_SECRET_VALUE" \
  -e DEBUG_COLORS=$SHOW_COLORS \
  -e NETWORK="$NETWORK" \
  -e ETHEREUM_RPC_URL=$ETHEREUM_RPC_URL \
  -e NODE_ENV=$ENVIRONMENT \
  -e MARKETS=$MARKETS \
  $DOCKER_PARAMS_LOCAL \
  $DOCKER_PARAMS_BOTS \
  $DOCKER_PARAMS_NETWORK \
  $DOCKER_IMAGE \
  $APP_COMMAND
