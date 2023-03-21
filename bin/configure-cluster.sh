#!/bin/bash

CORE_CONFIG_EXISTS=''
COMPUTE_CONFIG_EXISTS=''

# Get cluster name
read -p "Cluster Name: " CLUSTERNAME
while [[ -z "$CLUSTERNAME" ]] ; do 
     echo "ERROR: Answer cannot be blank"
     read -p "Cluster Name: " CLUSTERNAME
done

CORE_CONFIG="clusters/$CLUSTERNAME-hpc-core.sh"
COMPUTE_CONFIG="clusters/$CLUSTERNAME-compute-nodes.sh"

# Check for core configuration
if [ -f $CORE_CONFIG ] ; then
    echo "  Configuration for HPC Core already exists!"
    CORE_CONFIG_EXISTS="yes"
fi

# Check for compute configuration
if [ -f $COMPUTE_CONFIG ] ; then
    echo "  Configuration for Compute Nodes already exists!"
    COMPUTE_CONFIG_EXISTS="yes"
fi

# Create configuration files if not present
if [ -z $CORE_CONFIG_EXISTS ] ; then
    echo "  Creating HPC Core template: $CORE_CONFIG"
    echo "  $(cp -v etc/hpc-core.sh $CORE_CONFIG)"
fi

# Create configuration files if not present
if [ -z $COMPUTE_CONFIG_EXISTS ] ; then
    echo "  Creating Compute template: $COMPUTE_CONFIG"
    echo "  $(cp -v etc/compute-nodes.sh $COMPUTE_CONFIG)"
fi

# Open for editing
read -p "Open HPC Core configuration file for editing now? (Y/n) " EDIT_CORE
case $EDIT_CORE in
    [Yy]*)
        $EDITOR $CORE_CONFIG
        ;;
    [Nn]*)
        echo "  Proceeding without updating core configuration"
        ;;
    *)
        $EDITOR $CORE_CONFIG
        ;;
esac

read -p "Open Compute configuration file for editing now? (Y/n) " EDIT_COMPUTE
case $EDIT_COMPUTE in
    [Yy]*)
        $EDITOR $COMPUTE_CONFIG
        ;;
    [Nn]*)
        echo "  Proceeding without updating compute configuration"
        ;;
    *)
        $EDITOR $COMPUTE_CONFIG
        ;;
esac
