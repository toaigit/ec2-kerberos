Overview:

You will create an ec2 instance with Oracle Enterprise linux
   add sendmail using aws ses
   add kerberos and duo authentication
   perform dns push
   create users and authticated usinging sunetID password and Duo

The s3files folder contains files that you copy to your s3 bucket.
You need to have all these files to the bucket before running terraform.

----------
Your Tasks:
   update the vars.tf with your own values based on your AWS environment.
   update the s3files and add the s3files/* to your s3 bucket folders (infra and apps)
   Update your BUCKET_NAME in userdata.sh.
   Run terraform plan, apply to spawn up the ec2.
   Login to your ec2 and validate if the ec2 was created successfully.
      able to sudo su - root
      able to sudo su - appadmin 
      able to run docker ls (as appadmin user)
      check timezone is correctly set
      perform nslookup (internal and external)
   Don't forget to run terraform destroy.

---------
NOTEs:

How to find the ImageID of Oracle, Centos, Debian?
  Search Image by owner:
      Centos Account owner on AWS is 125523088429
      Debian Account owner on AWS is 136693071363
      Oracle Account owner on AWS is 131827586825

How to create ssh-key pair and upload to AWS?
  Use ssh-keygen to create your ssh-key
    ssh-keygen -t rsa -f myaws-keypair -C yourEmail
  Upload to your aws using cli command
    https://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html OR
    Using Terraform 
    resource "aws_key_pair" "deployer" {
       key_name   = "deployer-key"
       public_key = "ssh-rsa AAAAB3...abVohBK41 email@example.com"
     }

How to setup the credential ?
   Before running terraform plan, apply, you need to have your credential environment
   variables defined (AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_DEFAULT_REGION)

Security Watchout!
   You should never have your credential or your ssh private key stored on the folders.
