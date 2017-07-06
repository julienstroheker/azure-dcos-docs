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

## [Another option] Mount Share Directly to the running container via Service

Create the service using Docker Engine, check the `Grant Runtime Privileges` flag, update the following values in the script below.

`account_name`
`account_key`
`fileshare_name`

Prepend the following to your running command before kicking off the service:

```
account_name= && account_key= && fileshare_name= && local_folder=/tmp && apt-get update && apt-get -y install cifs-utils && mount -t cifs //$account_name.file.core.windows.net/$fileshare_name $local_folder -o vers=3.0,username=$account_name,password=$account_key,dir_mode=0777,file_mode=0777 && ls $local_folder
```
