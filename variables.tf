variable "kubernetes_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}

variable "aws_region" {
  description = "Default AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  default     = "b35_c3-en7SJ7e0P-5xxfDDhGIVZZBYOBUezlrJt"
}

variable "name" {
  description = "Name of the Organisation"
  type        = string
  default     = "exam-rnpc"
}

variable "domain_name" {
  description = "Domain Name"
  type        = string
  default     = "monlabo.de"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}