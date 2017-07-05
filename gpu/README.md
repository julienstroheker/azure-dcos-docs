# Enabling GPU support for DC/OS clusters using acs-engine

## Deployment

* `git clone https://github.com/julienstroheker/acs-engine.git`

* `cd acs-engine`

* `git checkout dcos-gpu`

* `wget https://raw.githubusercontent.com/julienstroheker/azure-dcos-docs/master/gpu/dcos-gpu-example.json -O examples/dcos-gpu-example.json` 

* Customize variables such as `dnsPrefix` (required), `keyData` (required), `vmSize` and `count` 

* `make devenv`

* For private agent nodes, make sure that `vmSize` is GPU VM such as NV or NC series (you can get more information about GPU VMs available here: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/)

* `make prereqs`

* `make build`

* `export RESOURCE_GROUP=<name for the resource group that is going to be created>`

* `export SUBSCRIPTION_ID=<your Azure subscription ID>`

* `export LOCATION=eastus` (make sure selected region supports GPU VMs)

* `./acs-engine deploy dcos-gpu-example.json --resource-group $RESOURCE_GROUP --subscription-id $SUBSCRIPTION_ID --location $LOCATION`

* Follow the instructions to login to Azure using https://aka.ms/devicelogin and enter the provided code

* Deployment will start and will take some time.

## Verifying GPU capabilities

* Once deployed, let's make sure that GPU drivers are deployed correctly

* `ssh -fNL 8000:localhost:80 azureuser@$RESOURCEGROUP.$REGION.cloudapp.azure.com`

* `dcos config set core.dcos_url http://localhost:8000`

* `dcos node --json`

* Verify that output contains gpu resource for each private agent GPU VM. Like so:

```
      "resources": {
        ...
        "gpus": 1,
        ...
      }
```

## Running and verifying Tensorflow GPU container

* `cd sample-container`

* `docker build -t ${USER}/dcos-gpu-sample .`

* `docker push ${USER}/dcos-gpu-sample`

* `dcos marathon app add deployment.json`

* `dcos task log`

* You should see the following output

```
Forked command at 18
Changing root to /var/lib/mesos/slave/provisioner/containers/aeaba7c5-e29d-479e-be7e-d3b15111afef/backends/overlay/rootfses/9dcaa71d-e189-405b-b01a-586fbaf7e259
Device mapping:
/job:localhost/replica:0/task:0/gpu:0 -> device: 0, name: Tesla K80, pci bus id: b052:00:00.0
MatMul: (MatMul): /job:localhost/replica:0/task:0/gpu:0
b: (Const): /job:localhost/replica:0/task:0/gpu:0
a: (Const): /job:localhost/replica:0/task:0/gpu:0
[[ 22.  28.]
 [ 49.  64.]]
Command exited with status 0 (pid: 18)
```

* If you are seeing the GPU mapping (similar to above output), it means it is working correctly.
