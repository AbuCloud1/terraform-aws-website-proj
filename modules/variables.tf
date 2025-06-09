variable "availability_zones" {
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "sg_ingress_ports" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [
    {
      description = "Allows HTTP traffic"
      port        = 80
    },
  ]
}