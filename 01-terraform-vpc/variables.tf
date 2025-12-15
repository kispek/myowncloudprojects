variable "aws_region" {
  default = "eu-central-1"
}
variable "project_name" {
  default = "MojePierwszeVPC"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16" #daje to duzej przestrzeni adresowej dla calej sieci
}

variable "public_subnet_a_cidr" {
  default = "10.0.1.0/24" # podsiec publiczna czyli mniejsce gfdzie bedzie jumphost (serwer przeskokowy - posrednik - bezpieczny punk dostepu do wewnetrznej sieci)
}
variable "private_subnet_a_cidr" {
  default = "10.0.101.0/24" #prywatna podsieć do serwera aplikacji 
}

variable "key_pair_name" {
  description = "Nazwa istniejacego klucza ssh w AWS, wymaganego do połączenia"
  default     = "MojKluczyk1"
}
