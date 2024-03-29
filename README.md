## Requirements

- Existing OpenStack Installation
- OpenStack CLI Tools Installed (both `python-openstackclient` and `python-heatclient`)
- OpenStack RC File (sourced to shell environment where creation scripts will be run from) 
- [Flight Solo 2023.2+](https://repo.openflighthpc.org/?prefix=images/FlightSolo/) Image in OpenStack

## How To

- Set cluster information in `hpc-cores.sh` (copy `hpc-core.sh.example` to `hpc-core.sh` if it doesn't exist for a jumping off point)
    - **Ensure that the corresponding private key to `SSH_KEY` is automatically used by your local `ssh` config as the create-hpc-core.sh script needs to login to the gateway node before moving on**
- Launch HPC core
  ```shell
  bash create-hpc-core.sh
  ```
- Set node information in `compute-nodes.sh` (copy `compute-nodes.sh.example` to `compute-nodes.sh` if it doesn't exist for a jumping off point)
- Launch either a set number of nodes or a scaling group that varies between 1 and the set `NODE_COUNT`
    - A) Launch set number of compute nodes
      ```shell
      bash create-compute-nodes.sh
      ```
    - B) Launch autoscaling group of compute nodes
      ```shell
      bash create-autoscale-compute-nodes.sh
      ```

Note: All scripts are created such that they can be run independently.

## Autoscaling

To change the number of nodes currently up in the autoscaling group, run:
```shell
bash modify-autoscale-compute-nodes.sh X
```

Where X is the desired number of nodes. OpenStack will then create/delete instances to reach this target. 

## Quick Launch - Gateway & Compute

For those wishing to quickly launch resources, the `create-all-in-one.sh` and `all-in-one.yaml` files exist to approach this. 

To launch:
- Set "General Cluster", "Network Config" and "Gateway" vars in `hpc-core.sh`
- Set variables in `compute-nodes.sh`
- Launch the cluster
    ```bash
    bash create-all-in-one.sh
    ```

After this there will be a gateway and X compute nodes launched with hunter auto-parsing all of the nodes. 

## Dev/Future Notes

Initial idea:
- A HPC Core template containing all resources 
    - A config file which sets conditions for which resources should be created and other configurable specs (e.g. network details)
    - A launch script that sources variables and launches the core template
- A node group template able to create X compute nodes
    - A config file which sets conditions and parameters for node creation
    - A launch script that sources variables for this and the HPC core to launch the nodes

To Do:
- Autoscaling Compute Node Group
- Add preconfigured variable scripts for different cluster types
    - Core: Small, Medium, Large
    - Compute: CPU optimised, Mem optimised
- Create DMZ network which is bridged to external and only gateway has access to
    - Make Pri & MGT internal from there
    - Pri network uses Gateway IP for routing to world
