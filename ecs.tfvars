variable "provider_name"{
 type = string    
}
variable "region"{
  type = string
  default = "ap-south-1"
}
variable vpccidr{
   type = string
   default = "192.168.0.0/25"
}

variable "key_name" {
  type = string
}

variable "prvcidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = list
  default     = ["192.168.0.0/27","192.168.0.32/27"]
} 


variable "pubcidr" {
  description = "Cidr blocks for public subnets"
  type = list
  default = ["192.168.0.64/27","192.168.0.96/27"]
  
}
variable "tenancy"{
  description = "want shared or dedicated tenancy"
  type = string
  default = "default"
}
variable "azs" {
  description = "availability zones"
  type = list
  default = ["ap-south-1a","ap-south-1b"]
  
}

variable "clusterName" {
  type  = string
  default = "demo-cluster"
  
}

variable "desired_capacity_asg" {
  type = number
  default = 2
  
}
variable "min_size_asg" {
  type = number
  default = 2
}
variable "max_size_asg" {
  type = number
  default = 2
}
variable "service_arn"{
  type = string
  description = "provide service arn which you can find in IAM console (taskExexutionRole)"
}
variable "ecs_ami" {
  type = string
  default = "ami-0df7a53affdc7cb92"
  description = "latest ecs-optimized ami"
  
}
variable "count_container" {
  type = number
  default = 5
}