#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source general variables
source $DIR/hpc-core.sh
source $DIR/compute-nodes.sh

# Checks
if [ -z "${OS_AUTH_URL}" ] ; then
    echo "No OpenStack auth identified, ensure that you've sourced your openstack rc file to setup the environment"
    exit 1
fi

openstack stack create -t $DIR/all-in-one.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter external-network="$EXTERNAL_NETWORK" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter network-cidr-pri="$NETWORK_PRI_CIDR" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter gateway-flavour="$SERVER_GATEWAY_FLAVOUR" \
    --parameter count="$NODE_COUNT" \
    --parameter node-flavour="$NODE_FLAVOUR" \
    "$CLUSTERNAME-all-in-one" --wait
