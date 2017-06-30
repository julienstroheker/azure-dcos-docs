# Mount Azure File to DC/OS Nodes

To persist data and enable sharing of data across multiple slave nodes, we can use Azure File. The following scripts mount the Azure File share to a local directory of each slave node and ensures the share is mounted after a node is rebooted.

## Create Azure File Share
Please reference [this](https://docs.microsoft.com/en-us/azure/storage/storage-azure-cli#create-and-manage-file-shares) to create and manage Azure file shares.

## Mount Share to DC/OS Nodes
From the master node, get the following scripts:

[cifsMount.sh](fileshare/cifsMount.sh)

[runForNodes.sh](fileshare/runForNodes.sh)

Update the following fields in `cifsMount.sh` with the credentials from last step of creating an Azure File share.

```
STORAGE_ACCOUNT_NAME=""
STORAGE_ACCOUNT_KEY=""
FILE_SHARE_NAME=""
LOCAL_FOLDER=""
```

Run the following script to mount the file share to all slave nodes.

```bash
$ bash runForNodes.sh

```
