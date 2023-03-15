#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source general variables
source $DIR/hpc-core.sh

# Checks 
if [ -z "${OS_AUTH_URL}" ] ; then
    echo "No OpenStack auth identified, ensure that you've sourced your openstack rc file to setup the environment"
    exit 1
fi

# Locate/prepare configuration 


# Launch Core
openstack stack create -t $DIR/hpc-core.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter external-network="$EXTERNAL_NETWORK" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter network-cidr-pri="$NETWORK_PRI_CIDR" \
    --parameter gateway-pri-ip="$SERVER_GATEWAY_PRI_IP" \
    --parameter gateway-flavour="$SERVER_GATEWAY_FLAVOUR" \
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
    "$CLUSTERNAME-hpc-core" --wait

GATEWAY_IP=$(openstack stack show "$CLUSTERNAME-hpc-core" -f yaml |grep gateway_ext_ip -A 1 |tail -1 |sed 's/.*: //g')
until ssh $GATEWAY_IP exit </dev/null 2>/dev/null ; do
    sleep 5
done
ssh root@$GATEWAY_IP "mkdir -p /root/.ssh && chmod 700 /root/.ssh"
scp $PRIV_KEY_TO_COPY_TO_GATEWAY root@$GATEWAY_IP:/root/.ssh/id_cluster
ssh root@$GATEWAY_IP "chmod 600 /root/.ssh/id_cluster && echo -e 'Host *\n  IdentityFile /root/.ssh/id_cluster\n  StrictHostKeyChecking  no' >> /root/.ssh/config"


echo "----- Core Deployment Complete -----"
echo "  Gateway IP: $GATEWAY_IP"

