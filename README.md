# lcloud-aws

This repo have all what's required to get my lcloud recruitment done.

## Initial setup and connection

To connect to AWS instance i used PuTTY

I've noticed i've been given `pem` file which putty is not accepting, so i used PuTTY Gen to convert it to private `ppk` file

Now i was able to connect to given instance using this key



## meta-data.sh

The S3 Bash Script Task is designed to gather metadata from an AWS EC2 instance, store it in a text file, and subsequently upload this file to a designated S3 bucket utilizing the AWS CLI. 

Scipt gathers info as described below:
- Instance ID
- Public IP
- Private IP
- Security groups
- OS
- User with sh permissions

## Jenkins_sysops

## Enable swap

I've been given information about how much disk free space is left. To confirm this i've checked the actuall disk free space with command: `df -h`

I've noticed i only have about 12 gigs of disk free space. So i've decided to create swap file of a size of 4GB by using commmand: `fallocate -l 4G /swapfile`
