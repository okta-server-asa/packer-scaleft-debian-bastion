# packer-scaleft-debian-bastion

This repository provides packer scripts to create a Debian 8 "Jessie" image, meant for use as a bastion, with ScaleFT's Server Tools baked into the image.

Images for both AWS EC2 and Google Cloud can be built, and the image is based on the official Debian 8 "Jessie" images for each cloud.  On AWS, this means `sftd` is started after `cloud-init`, and on Google Cloud `sftd` is started after `google-instance-setup` has run.

# Customizing

The `packer.json` file contains several variables for customizing the behavior of the built images:

- `scaleft_platform_url`: Sets the `InitialURL` in `/etc/sft/sftd.yaml`. Defaults to `https://app.scaleft.com`. 
- `scaleft_pkg_url`: Sets the URL for an Debian Apt repository.  Defaults to: `https://pkg.scaleft.com`.  If you want to use a testing channel version of `scaleft-server-tools`, set this to `https://pkg-testing.scaleft.com`.
- `image_name`: Name of the exported image. Defaults to: `scaleft-debian-8-bastion`.

## AWS Specific options

- `aws_ami_regions`: List of regions to copy the final AMI into.
- `aws_ami_groups`: [LaunchPermission Group]((http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_LaunchPermission.html)) to share the resulting AMIs with.  Only valid value is empty or `all`.

## Google Cloud Specific options

- `gcp_project_id`: Google Cloud Project to build image in.

# Building an image on Google Cloud

```
packer build -only googlecompute \
  -var gcp_project_id=your-image-builder \
  packer.json

gcloud compute images list --no-standard-images --project your-image-builder

gcloud compute instances create test-bastion1 \
  --image-project=your-image-builder \
  --image-family=scaleft-debian-8-bastion \
  --zone=us-west1-a \
  --metadata=scaleft-enrollment-token=${SCALEFT_ENROLLMENT_TOKEN}
```


# Building an image on AWS EC2

```
packer build -only amazon-ebs \
  -var aws_ami_regions=us-west-2,us-east-1 \
  -var aws_ami_groups=all \
  -var scaleft_pkg_url=https://pkg-testing.scaleft.com \
  packer.json
```

