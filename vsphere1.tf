resource "restapi_object" "secure_mesh_site_1" {
  id_attribute = "metadata/name"
  path         = "/config/namespaces/system/securemesh_sites"
  data         = local.vsphere1
}

module "vsphere1" {
  depends_on       = [ restapi_object.secure_mesh_site_1 ]
  source           = "./modules/f5xc/ce/vsphere"
  f5xc_tenant      = var.f5xc_tenant
  f5xc_api_url     = var.f5xc_api_url
  f5xc_namespace   = var.f5xc_namespace
  f5xc_api_token   = var.f5xc_api_token
  f5xc_api_ca_cert = var.f5xc_api_ca_cert
  f5xc_reg_url     = var.f5xc_reg_url
  # f5xc_ova_image         = var.f5xc_ova_image
  f5xc_vm_template   = var.f5xc_vm_template
  vsphere_user       = var.vsphere_user
  vsphere_password   = var.vsphere_password
  vsphere_server     = var.vsphere_server
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_cluster    = var.vsphere_cluster

  # F5 SJC lab
  #nodes   = [
  #  { name = "master-0", host = "10.200.0.100", datastore = "datastore-esxi-1", ipaddress = "10.200.2.145/22" },
  #  { name = "master-1", host = "10.200.0.100", datastore = "datastore-esxi-1", ipaddress = "10.200.2.146/22" },
  #  { name = "master-2", host = "10.200.0.100", datastore = "datastore-esxi-1", ipaddress = "10.200.2.147/22" }
  #]
  #publicdefaultgateway   = "10.200.0.1"
  #outside_network        = "VM Network"

  # marcel colo
  nodes = [
    { name = "master-0", host = "192.168.40.100", datastore = "datastore2", ipaddress = "192.168.40.111/24" },
    { name = "master-1", host = "192.168.40.100", datastore = "datastore2", ipaddress = "192.168.40.112/24" },
    { name = "master-2", host = "192.168.40.100", datastore = "datastore2", ipaddress = "192.168.40.113/24" }
  ]
  publicdefaultgateway = "192.168.40.1"
  outside_network      = "VM Network"

  dnsservers = {
    primary   = "8.8.8.8"
    secondary = "8.8.4.4"
  }
  publicdefaultroute = "0.0.0.0/0"
  guest_type         = "centos64Guest"
  cpus               = 4
  memory             = 16384
  certifiedhardware  = "vmware-voltmesh"
  cluster_name       = format("%s-vsphere1", var.project_prefix)
  sitelatitude       = "37.4"
  sitelongitude      = "-121.9"
}

locals {
  vsphere1 = jsonencode({
    "metadata" : {
      "name" : format("%s-vsphere1", var.project_prefix)
      "namespace" : "system",
      "labels" : {
        "site-mesh" : var.project_prefix
      },
      "annotations" : {},
      "disable" : false
    },
    "spec" : {
      "volterra_certified_hw" : "vmware-voltmesh",
      "master_node_configuration" : [
        {
          "name" : "master-0"
        },
        {
          "name" : "master-1"
        },
        {
          "name" : "master-2"
        }
      ],
      "worker_nodes" : [],
      "no_bond_devices" : {},
      "default_network_config": {},
      "coordinates" : {
        "latitude" : 0,
        "longitude" : 0
      },
      "logs_streaming_disabled" : {},
      "default_blocked_services" : {},
      "offline_survivability_mode" : {
        "no_offline_survivability_mode" : {}
      }
    }
  })
}

output "secure_mesh_site_1" {
  value = restapi_object.secure_mesh_site_1.api_response
}

output "vsphere1" {
  value = module.vsphere1
}
