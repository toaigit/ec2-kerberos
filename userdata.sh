#!/bin/bash
#  basice userdata for an ec2 with docker engine

echo "Info: Executing userdata.sh script."

export BUCKET_NAME=mydemo.resourceonline.org
/usr/bin/timedatectl set-timezone America/Los_Angeles

export INSTID=`curl http://169.254.169.254/latest/meta-data/instance-id`
export REGION=`curl -s http://169.254.169.254/latest/meta-data/public-hostname | awk -F. '{print $2}'`
export PRIVIP=`curl -s curl http://169.254.169.254/latest/meta-data/local-ipv4`

# install some basic packages
dnf install -y dnf-utils zip unzip git bind-utils mailx
dnf install -y sendmail sendmail-cf m4 cyrus-sasl-plain

#  install aws 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
aws/install
rm -rf aws awscliv2.zip

# install kerberos client
dnf install -y krb5-workstation
aws s3 cp s3://$BUCKET_NAME/infra/pam_krb5-4.11-1.el8.x86_64.rpm /tmp
dnf install -y /tmp/pam_krb5-4.11-1.el8.x86_64.rpm

# install duo
aws s3 cp s3://$BUCKET_NAME/infra/duosecurity.repo /etc/yum.repos.d
rpm --import https://duo.com/DUO-GPG-PUBLIC-KEY.asc
dnf install -y duo_unix
aws s3 cp s3://$BUCKET_NAME/infra/pam_duo.conf /etc/duo/pam_duo.conf
chmod 700 /etc/duo/pam_duo.conf

# config kerberos
aws s3 cp s3://$BUCKET_NAME/infra/krb5.conf /etc/krb5.conf
aws s3 cp s3://$BUCKET_NAME/infra/sshd_config /etc/ssh/sshd_config
aws s3 cp s3://$BUCKET_NAME/infra/password-auth /etc/pam.d/password-auth

systemctl stop sshd
systemctl start sshd

export HN=`aws ec2 describe-instances --instance-id $INSTID --region $REGION --query 'Reservations[*].Instances[*].[PublicIpAddress,Tags[?Key==\`Name\`]]' --output text | grep Name | awk '{print $2}'`

hostnamectl set-hostname $HN.resourceonline.org
echo "$PRIVIP $HN.local.io $HN" >> /etc/hosts

echo PS1=\"[\\u@$HN]\" >> /etc/bashrc 
cat /etc/hosts | sed "s/localhost/localhost $HN/" > /tmp/hosts
cp -p /tmp/hosts /etc/hosts

systemctl restart sshd.service

#  add docker repository (optional)
#dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
#  install docker and docker-composer (optional)
#dnf remove -y runc
#dnf install -y docker-ce --nobest
#  install docker-compose (optional)
#sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
#systemctl start docker

#  create team member acounts 
echo "Info:  create team member accounts ..."
cd /tmp
aws s3 cp s3://$BUCKET_NAME/apps/users.list /tmp/users.list
git clone https://github.com/toaigit/post-scripts.git
cd /tmp/post-scripts
./runadduser-v2 /tmp/users.list

#  Add user appadmin application docker account - optional
#useradd -s /bin/bash -m -d /home/appadmin -c "Application Admin" appadmin
#usermod -a -G docker appadmin

# setup sendmail with ses smtp credential (which come from your s3 bucket
echo "Info:  Setting sendmail"
cd /tmp
git clone https://github.com/toaigit/ses-mailx.git
cd /tmp/ses-mailx
aws s3 cp s3://$BUCKET_NAME/infra/authinfo authinfo
./update.sh

# RUN runcmd-v2 will figure out if there is any additional filesystem to attach and mount.
# RUN runeip-v2 to see if a reserved fixed IP need to be set for this server.
#cd /tmp/post-scripts
#./runcmd-v2
#./runeip-v2

#  update dns
echo "Info:  Update DNS records"
cd /tmp
git clone https://github.com/toaigit/update-route53.git
cd update-route53
./update.dns

#  clean up
cd /tmp
/bin/rm -rf ses-mailx post-scripts update-route53

echo "Info: Completed the userdata.sh script"
#  end of userdata script
