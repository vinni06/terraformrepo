variable "key_name" {
  default = "meghanamumbai"
}

variable "pvt_key" {
  default = "/root/.ssh/mkey.pem"
}

variable "us-east-zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg-id" {
  default = "sg-0eb024eb164eb86c0"
}
