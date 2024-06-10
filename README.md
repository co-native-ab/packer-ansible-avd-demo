# Azure Virtual Desktop - Packer

## Pre requisites

> Everything is done from WSL2.

### Packer

```shell
cd /tmp
wget https://releases.hashicorp.com/packer/1.11.0/packer_1.11.0_linux_amd64.zip
sudo mv packer /usr/bin/
```

### Ansible

```shell
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

## How to run

### Create variables file

> Make sure to modify the variables

```shell
mkdir .tmp/
cat <<EOT > .tmp/variables.pkrvars.hcl
build_resource_group_name         = ""
subscription_id                   = ""
tenant_id                         = ""
managed_image_resource_group_name = ""
EOT
```

### Run packer

```shell
az login
source .venv/bin/activate
packer init avd.pkr.hcl
packer build -var-file="./.tmp/variables.pkrvars.hcl" avd.pkr.hcl
```
