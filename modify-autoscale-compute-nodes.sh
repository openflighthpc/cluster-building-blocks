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

if [ -z "$1" ] ; then
    echo "Follow the script with the desired number of nodes. Must be between 1 and $NODE_COUNT"
    exit 1
fi

UP=$1

# Identify resource IDs
core_resources="$(openstack stack resource list "$CLUSTERNAME-hpc-core-base" -f yaml)"
network_id="$(echo "$core_resources" |grep 'cluster-network$' -B 1 |head -1 |sed 's/.*: //g')"
network_pri_id="$(echo "$core_resources" |grep 'cluster-network-pri$' -B 1 |head -1 |sed 's/.*: //g')"
sg_id="$(echo "$core_resources" |grep 'cluster-sg$' -B 1 |head -1 |sed 's/.*: //g')"

# Launch Core
openstack stack update -t $DIR/autoscale-compute-nodes.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter cluster-network="$network_id" \
    --parameter cluster-network-pri="$network_pri_id" \
    --parameter cluster-sg="$sg_id" \
    --parameter count="$NODE_COUNT" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter node-flavour="$NODE_FLAVOUR" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter up="$UP" \
    "$CLUSTERNAME-autoscale-compute-nodes" --wait

