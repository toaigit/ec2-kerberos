variable  "SERVERNAME" {
  default = "mydemo"
}

variable  "CREATOR" {
  default = "Toai Vo"
}

variable  "REGION" {
  default = "us-west-2"
}

variable "ASG_NAME" {
   default = "mydemo"
  }

variable "LC_NAME" {
   default = "mydemo"
  }

variable "SUBNET1" {
   default = "subnet-d258eba4"
  }
variable "SUBNET2" {
   default = "subnet-cb1e86af"
  }
variable "SUBNET3" {
   default = "subnet-75b5712d"
  }

variable "MIN_SIZE" {
   default = "1"
  }

variable "MAX_SIZE" {
   default = "1"
  }

variable "ASG_DESIRE" {
   default = "1"
  }

variable "HEALTH_CHECK_GRACE_PERIOD" {
   default = "300"
  }

#  debian bullseye "ami-0c1b4dff690b5d229"
#  default OEL 8.7 = "ami-07ec38a03db614220"
variable "IMAGE_ID" {
   default = "ami-07ec38a03db614220"
  }

variable "INSTANCE_TYPE" {
   default = "t2.micro"
  }

variable "KEY_NAME" {
   default = "tony-keypair"
  }

variable "SG" {
   default = "sg-05f46cbe3ac82be76"
  }

variable "VOLUME_TYPE" {
   default = "gp2"
  }

variable "VOLUME_SIZE" {
   default = "16"
  }

variable "IAMROLE" {
   default = "Toai-S3EC2Role"
  }

variable "DELETE_ON_TERMINATION" {
   default = "true"
  }
