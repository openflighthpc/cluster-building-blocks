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

# Locate/prepare configuration 



echo "----- Core Deployment Start -----"

# Launch Core
openstack stack create -t $DIR/hpc-core-base.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter external-network="$EXTERNAL_NETWORK" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter network-cidr-pri="$NETWORK_PRI_CIDR" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter gateway-flavour="$SERVER_GATEWAY_FLAVOUR" \
    "$CLUSTERNAME-hpc-core-base" --wait

GATEWAY_IP=$(openstack stack show "$CLUSTERNAME-hpc-core-base" -f yaml |grep gateway_ext_ip -A 1 |tail -1 |sed 's/.*: //g')

# Wait for Gateway to be up
count=1
countmax=30

echo "$count/$countmax: Waiting for gateway1 to be accessible..."
count=$((count + 1))
until ssh -q -o StrictHostKeyChecking=no flight@$GATEWAY_IP exit </dev/null 2>/dev/null ; do
    echo "$count/$countmax: Waiting for gateway1 to be accessible..."
    sleep 5
    count=$((count + 1))
    if [[ $count == $countmax ]] ; then
        echo "ERROR: Failed to access gateway1 at '$GATEWAY_IP'!"
        echo "Exiting..." 
        exit 1
    fi
done

GATEWAY_PUB_KEY="$(ssh -q -o StrictHostKeyChecking=no flight@$GATEWAY_IP 'sudo cat /root/.ssh/id_alcescluster.pub' 2>/dev/null)"

# Launch services
core_resources="$(openstack stack resource list "$CLUSTERNAME-hpc-core-base" -f yaml)"
network_id="$(echo "$core_resources" |grep 'cluster-network$' -B 1 |head -1 |sed 's/.*: //g')"
network_pri_id="$(echo "$core_resources" |grep 'cluster-network-pri$' -B 1 |head -1 |sed 's/.*: //g')"
sg_id="$(echo "$core_resources" |grep 'cluster-sg$' -B 1 |head -1 |sed 's/.*: //g')"

openstack stack create -t $DIR/hpc-core-services.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter ssh-key="$GATEWAY_PUB_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter cluster-network="$network_id" \
    --parameter cluster-network-pri="$network_pri_id" \
    --parameter cluster-sg="$sg_id" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter infra01-create="$SERVER_INFRA01_CREATE" \
    --parameter infra01-pri-ip="$SERVER_INFRA01_PRI_IP" \
    --parameter infra01-flavour="$SERVER_INFRA01_FLAVOUR" \
    --parameter infra02-create="$SERVER_INFRA02_CREATE" \
    --parameter infra02-pri-ip="$SERVER_INFRA02_PRI_IP" \
    --parameter infra02-flavour="$SERVER_INFRA02_FLAVOUR" \
    --parameter storage1-create="$SERVER_STORAGE1_CREATE" \
    --parameter storage1-pri-ip="$SERVER_STORAGE1_PRI_IP" \
    --parameter storage1-flavour="$SERVER_STORAGE1_FLAVOUR" \
    --parameter storage1-mount-disk-size="$SERVER_STORAGE1_MOUNT_DISK_SIZE" \
    "$CLUSTERNAME-hpc-core-services" --wait

echo "----- Compute Deployment Start -----"

# Launch compute
openstack stack create -t $DIR/compute-nodes.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter cluster-network="$network_id" \
    --parameter cluster-network-pri="$network_pri_id" \
    --parameter cluster-sg="$sg_id" \
    --parameter count="$NODE_COUNT" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter node-flavour="$NODE_FLAVOUR" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter ssh-key="$GATEWAY_PUB_KEY" \
    "$CLUSTERNAME-compute-nodes" --wait

echo "----- Cluster Deployment Complete -----"
echo "  Gateway IP: $GATEWAY_IP"
