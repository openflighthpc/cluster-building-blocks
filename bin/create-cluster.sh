#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get cluster name
read -p "Cluster Name: " CLUSTERNAME
while [[ -z "$CLUSTERNAME" ]] ; do
     echo "ERROR: Answer cannot be blank"
     read -p "Cluster Name: " CLUSTERNAME
done

# Configure
$DIR/configure-cluster.sh $CLUSTERNAME

# Check for Build
read -p "Launch resources now? (Y/n) " LAUNCH
case $LAUNCH in
    [Yy]*)
        ;;
    [Nn]*)
        echo "Not creating resources"
        exit 0
        ;;
    *)
        ;;
esac

# Create Core
$DIR/create-hpc-core.sh $CLUSTERNAME

# Create Compute 
$DIR/create-compute-nodes.sh $CLUSTERNAME
