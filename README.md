# lcloud-aws

This repo have all what's required to get my lcloud recruitment done.

## Initial setup and connection

To connect to AWS instance i used PuTTY

I've noticed i've been given `pem` file which putty is not accepting, so i used PuTTY Gen to convert it to private `ppk` file

Now i was able to connect to given instance using this key

First thing to do was to update repos by:

`sudo apt-get update`


## meta-data.sh

The S3 Bash Script Task is designed to gather metadata from an AWS EC2 instance, store it in a text file, and subsequently upload this file to a designated S3 bucket utilizing the AWS CLI. 

To be able to execute this script i needed to have AWS CLI installed on the instance

The first thing what i've done was to install AWS CLI with `sudo apt-get install awscli` but apt return no such result of a package `awscli`.

So i've tried with `sudo apt-get install aws-cli` and again still no results. 

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

### Enable swap

I've been given information about how much disk free space is left. To confirm this i've checked the actuall disk free space with command: 

`df -h`

To confirm i am not using any swap i used `htop` to verify no swap is activated and no such swap memory have been used

I've noticed i only have about 12 gigs of disk free space. So i've decided to create swap file of a size of 4GB by using commmand: 

`sudo fallocate -l 4G /swapfile`



I've given proper permission to the file so only the root can modify it's contents:

`sudo chmod 600 /swapfile`


I've formatted the file so it can be used as a swap:

`sudo mkswap /swapfile`


And enabled swap file by using:

`sudo swapon /swapfile`

To confirm swap have been enabled i've cheked it with `htop` and the swap file has been enabled with a size of 4GB

### Installing jenkins 

To install jenkins i need to install openjdk 

So i've installed it with:

`sudo apt install openjdk-17-jdk -y`

Next thing to do is to add repo key and repo to apt

`sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key`

`echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
`

After adding previous ones i was able to install jenkins. But firstly i need to update repos
`sudo apt-get update`

And now i am able to install jenkins

`sudo apt-get install jenkins`

Now i have to check if jenkins service have started or not 

`sudo systemctl status jenkins`

Ok. jenkins service has already been running if it wouldn't would have to use:

`sudo systemctl start jenkins`


To confirm jenkins is running i've entered given ip to the instane and tried connecting to jenkins with by web browser by using:

`<given_ip>:8080` and it was running, YAY



Next task was to configure reverse proxy so the jenkins can be accessed by an URL jenkins.<given_domain>

First what i needed to do was to install nginx to do such a thing:

`sudo apt-get install nginx`

After that i need to create proper configuration of reverse proxy for nginx so i've created a configuration file `jenkins` in this path:

`/etc/nginx/sites-available/jenkins`

The content of this configurationa are as below:

```
server {
    listen 80;
    server_name jenkins.<given_domain>;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Afer writing config i've activated it with:

`sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/`


And restarted jenkins

`sudo systemctl restart jenkins`

Now i was able to acceess jenkins with an url `jenkins.<given_domain>`

I've unlocked the jenkins with the path provived on website and installed required plugins


Also with:


```
export DOMAIN="jenkins.<given_domain>"
export ALERTS_EMAIL="webmaster@example.com"

sudo certbot --nginx --redirect -d $DOMAIN --preferred-challenges http --agree-tos -n -m $ALERTS_EMAIL --keep-until-expiring

sudo systemctl restart nginx
```
I've configured SSL certificate




## Gitlab task

To install gitlab and configure it properly first thing i need to do is to install dependencies. To use correct installation steps i've used the install instruction from official gitlab website `https://about.gitlab.com/install/#ubuntu`

`sudo apt-get install -y curl openssh-server ca-certificates tzdata perl postfix`

Postfix asked me to select configuration for now i've selected `No Configuration`

Next step is to add the GitLab package repository and install the package:

`curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash`

`sudo EXTERNAL_URL="https://gitlab.<given_domain>" apt-get install gitlab-ce`


Next step is to configure GitLab their own configuration tool:

`sudo gitlab-ctl reconfigure` This command took a very long time to finish 

Now i need to configure HTTPS using Let's Encrypt certificate

I need to enable automatic certificate regeneration in file `/etc/gitlab/gitlab.rb`

In this file i've uncommented following lines and changed them according to instruction:

```

external_url 'https://gitlab.<given_domain>'

....
nginx['enable'] = true
ngninx['redirect_http_to_https'] = false
```

And reconfigured gitlab again

`sudo gitlab-ctl reconfigure`

Now i went to `https://gitlab.<given_domain>` and im wating for gitlab to start
