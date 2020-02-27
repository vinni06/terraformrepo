variable "key_name" {
  default = "vinnikey"
}

variable "pvt_key" {
  default = "/root/.ssh/vinnikey.pem"
}

variable "us-east-zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg-id" {
  default = "sg-0ab4771577b966dd3"
}
