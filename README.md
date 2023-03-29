## Requirements

- Existing OpenStack Installation
- OpenStack CLI Tools Installed (both `python-openstackclient` and `python-heatclient`)
- OpenStack RC File (sourced to shell environment where creation scripts will be run from) 
- [Flight Solo 2023.2+](https://repo.openflighthpc.org/?prefix=images/FlightSolo/) Image in OpenStack

## How To

- Set cluster information in `hpc-cores.sh`
- Launch HPC core
  ```shell
  bash create-hpc-core.sh
  ```
- Set node information in `compute-nodes.sh`
- Launch compute nodes
  ```shell
  bash create-compute-nodes.sh
  ```

Note: All scripts are created such that they can be run independently. 

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
- Improve structure and interaction
    - Separate dirs for scripts, vars, etc
    - Create copies of the variable scripts named after cluster (if not existing, allows for dropping in configs) 
    - Add preconfigured variable scripts for different cluster types
        - Core: Small, Medium, Large
        - Compute: CPU optimised, Mem optimised
    - Enforce core existing before creating compute nodes
- Create DMZ network which is bridged to external and only gateway has access to
    - Make Pri & MGT internal from there
    - Pri network uses Gateway IP for routing to world
- Ensure correct private key for access is avail for SSH command into gateway
