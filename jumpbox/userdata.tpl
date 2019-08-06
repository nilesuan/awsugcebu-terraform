#!/bin/bash

export shortname=${shortname}
export eipallocationid=${eipallocationid}

# non interactive update and upgrade
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "CONFIGURING"
#unset UCF_FORCE_CONFFOLD
#export UCF_FORCE_CONFFNEW=YES
#ucf --purge /boot/grub/menu.lst
#export DEBIAN_FRONTEND=noninteractive
#sed -i'' -e 's/.*requiretty.*//' /etc/sudoers
apt update
#apt -o Dpkg::Options::="--force-confnew" --allow -fuy dist-upgrade

# fetch aws constants
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "FETCHING AWS CONSTANTS"
export availabilityzone="`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone || die \"wget availability-zone has failed: $?\"`"
echo "Availability Zone: $availabilityzone"
export region="`echo \"$availabilityzone\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo "Region: $region"
export ec2instanceid="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
echo "EC2 Instance ID: $ec2instanceid"
export AWS_DEFAULT_REGION=$region

# install aws cli
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "INSTALLING AWS TOOLS"
apt install -y python python3-pip
/usr/bin/pip3 install --upgrade pip3
/usr/bin/pip3 install --upgrade boto3
/usr/bin/pip3 install --upgrade awscli
/usr/bin/pip3 install --upgrade "urllib3==1.22"

# associate elastic IP
echo "---------------------------------------------------------------------------------------------------------------------------------------------"
echo "ASSOCIATING ELASTIC IP"
/usr/local/bin/aws ec2 associate-address --instance-id $ec2instanceid --allocation-id $eipallocationid