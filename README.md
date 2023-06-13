# MediaWiki and Database Deployment

**Demo URL:** http://a3c35c50ffd92417b985bdebdbc2a526-641227410.ap-south-1.elb.amazonaws.com/

This repository contains the necessary files and instructions for deploying MediaWiki and the associated database on Kubernetes using Helm charts. It also includes the Dockerfile for building the Docker image of MediaWiki and Database also the Terraform code for creating the AWS infrastructure such as VPC and EKS.

## Prerequisites
* AWS CLI installed and configured
* Docker
* kubectl
* helm
## Docker Image Build Steps

To build the MediaWiki Docker image, follow these steps:

1. Go to the root directory of the repository.
2. Build the MediaWiki Docker image:
   ```shell
   docker build -t <tagName> .
   ```
3. Push the MediaWiki Docker image to a container registry:
   ```shell
   docker push <tagName>
   ```

To build the database Docker image (using Percona MySQL as the base image), follow these steps:

1. Go to the `database` directory in the repository.
2. Build the database Docker image:
   ```shell
   docker build -t <tagName> .
   ```
3. Push the database Docker image to a container registry:
   ```shell
   docker push <tagName>
   ```

## AWS Infrastructure Creation

To create the AWS infrastructure using Terraform, follow these steps:

1. Go to the `terraform` directory in the repository.
2. Initialize Terraform:
   ```shell
   terraform init
   ```
3. Apply the Terraform configuration to create the infrastructure:
   ```shell
   terraform apply
   ```
   review the changes and type yes to continue.

## Deployment

To deploy the MediaWiki and database on Kubernetes using Helm, follow these steps:

1. Go to the `charts` directory in the repository.
2. Deploy the database using Helm:
   ```shell
   helm upgrade --install <releaseName> mysql
   ```
3. Deploy MediaWiki using Helm:
    ```shell
    helm upgrade --install <releaseName> mediawiki
    ```

**Note:** Do not forget to change the credentials in database and mediawiki helm chart.

Default admin login credentials for mediawiki:

username: admin

password: admin@1234! (change password on first login.)

After following these steps, you should have MediaWiki and the associated database deployed and running on your Kubernetes cluster.

# Updating LocalSettings.php
You can easily update the `LocalSettings.php` file by updating the corresponding ConfigMap and restarting the deployment. Here's how you can do it:
1. Locate the ConfigMap associated with MediaWiki deployment.
2. Update the LocalSettings.php data in the ConfigMap with the desired configuration.
3. Save the changes to the ConfigMap and use helm command to apply the changes.
    ```shell
    helm upgrade --install <releaseName> mediawiki
    ```

4. Restart the MediaWiki deployment to apply the updated LocalSettings.php:
    ```shell
    kubectl rollout restart deployment mediawiki -n <namespace>
    ```


Please refer to the individual directories and files in this repository for more detailed instructions and configuration options.