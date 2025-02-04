# lcloud-aws

This repo have all what's required to get my lcloud recruitment done.

## Initial setup and connection

To connect to AWS instance i used PuTTY

I've noticed i've been given `pem` file which putty is not accepting, so i used PuTTY Gen to convert it to private `ppk` file

Now i was able to connect to given instance using this key

First thing to do was to update repos by:

`apt-get update`


## meta-data.sh

The S3 Bash Script Task is designed to gather metadata from an AWS EC2 instance, store it in a text file, and subsequently upload this file to a designated S3 bucket utilizing the AWS CLI. 

To be able to execute this script i needed to have AWS CLI installed on the instance

The first thing what i've done was to install AWS CLI with `apt-get install awscli` but apt return no such result of a package `awscli`.

So i've tried with `apt-get install aws-cli` and again still no results. 

But this time shell suggested that `aws-cli` is available to install with snap.

So i've installed is with `snap install aws-cli` and used it properly in my script to gather information as described below:

Scipt gathers info as described below:
- Instance ID
- Public IP
- Private IP
- Security groups
- OS
- User with sh permissions

## Jenkins_sysops

## Enable swap

I've been given information about how much disk free space is left. To confirm this i've checked the actuall disk free space with command: 

`df -h`

To confirm i am not using any swap i used `htop` to verify no swap is activated and no such swap memory have been used

I've noticed i only have about 12 gigs of disk free space. So i've decided to create swap file of a size of 4GB by using commmand: 

`fallocate -l 4G /swapfile`



I've given proper permission to the file so only the root can modify it's contents:

`chmod 600 /swapfile`


I've formatted the file so it can be used as a swap:

`mkswap /swapfile`


And enabled swap file by using:

`swapon /swapfile`

## Installing jenkins 
To confirm swap have been enabled i've cheked it with `htop` and the swap file has been enabled with a size of 4GB
