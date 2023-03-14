

- A HPC Core template containing all resources 
- A config file which sets conditions for which resources should be created and other configurable specs (e.g. network details)
- A launch script that sources variables and launches the core template


- A node group template able to create X compute nodes
- A config file which sets conditions and parameters for node creation
- A launch script that sources variables for this and the HPC core to launch the nodes

To Do
- Set FQDNs in the name property of server creation
- Create DMZ network which is bridged to external and only gateway has access to
    - Make Pri & MGT internal from there
    - Pri network uses Gateway IP for routing to world
