# Build IBM Cloud Packer image using Github Actions

## Base image

The following example uses the Ubuntu 22.04 image as the base image, but as new iterations are pushed to our public image repository, image ID will be incremented. To pull the latest `Ubuntu` VPC image, you can use the following command:

    ```shell
    ibmcloud is images --visibility public --output json | jq -r '.[] | select(.status=="available") | select(.operating_system.architecture=="amd64") | select(.name | startswith("ibm-ubuntu")) | .name,.id'
    ```

## Build image

