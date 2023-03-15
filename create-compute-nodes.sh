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

# Identify resource IDs
core_resources="$(openstack stack resource list "$CLUSTERNAME-hpc-core" -f yaml)"
network_id="$(echo "$core_resources" |grep 'cluster-network$' -B 1 |head -1 |sed 's/.*: //g')"
network_pri_id="$(echo "$core_resources" |grep 'cluster-network-pri$' -B 1 |head -1 |sed 's/.*: //g')"
sg_id="$(echo "$core_resources" |grep 'cluster-sg$' -B 1 |head -1 |sed 's/.*: //g')"

# Launch Core
openstack stack create -t $DIR/compute-nodes.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter cluster-network="$network_id" \
    --parameter cluster-network-pri="$network_pri_id" \
    --parameter cluster-sg="$sg_id" \
    --parameter count="$NODE_COUNT" \
    "$CLUSTERNAME-compute-nodes" --wait

