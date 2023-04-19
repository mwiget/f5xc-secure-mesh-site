terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.20"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.3.1"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "1.18.0"
    }
  }
}

