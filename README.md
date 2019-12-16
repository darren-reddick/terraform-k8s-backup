# terraform-k8s-backup

This repository contains the Terraform code used to create scheduled backups for a Kubernetes control plane using AWS Systems Manager from [this blog post](https://devopsgoat.home.blog/2019/11/30/k8s-backups-with-systems-manager/)

The following resources are created:
* S3 Bucket
* SSM document
* Cloudwatch Event Rule
* IAM role for Cloudwatch Events



## Usage
```
terraform init
terraform plan
terraform apply
```


## Terraform Versions
This example supports Terraform v0.12
