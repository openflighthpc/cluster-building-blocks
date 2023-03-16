# General Cluster
CLUSTERNAME="stutest1"
EXTERNAL_NETWORK="dmz"
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWD9MAHnS5o6LrNaCb5gshU4BIpYfqoE2DCW9T2u3v4xOh04JkaMsIzwGc+BNnCh+NlkSE9sPVyPODCVnLnHdyyNfUkLBIUGCM/h9Ox7CTnsbmhnv3tMp4OD2dnGl+wOXWo/0YrWA0cpcl5UchCpZYMGscR4ohg8+/panBJ0//wmQZmCUZkQ20TLumYlL9HdmFl2SO2vraY+nBQCoHtPC80t4BmbPg5atEnQVMngpsRqSykIoUEQKh49t649cF3rBboZT+AmW+O1GWVYu7qlUxqIsdTRJbqbhZ/W2n3rraQh5CR/hOyYikkdn3xqm7Rom5iURvWd6QBh0LhP1UPRIT"

#SOLO_IMAGE="Flight Solo 2023.1"
SOLO_IMAGE="SOLO2-2023.2-1503231348-STUHOTFIX"

# Network Config
NETWORK_PRI_CIDR="10.100.0.0/16"

# Gateway
SERVER_GATEWAY_PRI_IP="10.100.0.101"
SERVER_GATEWAY_FLAVOUR="m1.small"

# Infra01
SERVER_INFRA01_CREATE="true"
SERVER_INFRA01_PRI_IP="10.100.0.51"
SERVER_INFRA01_FLAVOUR="m1.small"

# Infra02
SERVER_INFRA02_CREATE="true"
SERVER_INFRA02_PRI_IP="10.100.0.52"
SERVER_INFRA02_FLAVOUR="m1.small"

# Storage
SERVER_STORAGE1_CREATE="true"
SERVER_STORAGE1_PRI_IP="10.100.0.11"
SERVER_STORAGE1_FLAVOUR="m1.medium"

SERVER_STORAGE1_MOUNT_DISK_SIZE="50" # Size of mounted disk, in GB
