#!/bin/bash

yum -y upgrade

yum -y install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
amazon-linux-extras install postgresql13
systemctl restart amazon-ssm-agent