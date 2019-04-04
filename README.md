# Docker image with gcloud sdk, helm & kubectl cli tools

This is yet another docker image with gcloud, helm & kubectl command line tools made for automated deployments.

The idea is that you should own an image which you use in your CI for deployment, so we have our own copy too.

Use this one at your own risk!

## Details

Tags:

* `241.0.0` - gcloud `241.0.0`; helm `2.13.1`; kubectl `1.14.0`;


## Docker pull

```shell
docker pull quay.io/evl.ms/gcloud-helm:241.0.0
```