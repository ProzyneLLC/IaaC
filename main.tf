terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.21.1"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  base_cidr_block = "10.0.0.0/16"
  azurerm_resource_group = "prozyne-dev"
  azurerm_resource_group_location = "West Europe"
}

module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = local.base_cidr_block

  networks = [
    {
      name     = "prozyne-dev-vm-cidr"
      new_bits = 8
    },
    {
      name     = "prozyne-dev-k8s-cidr"
      new_bits = 4
    },
  ]
}

data "azurerm_ssh_public_key" "prozyne-dev-key" {
  name                = "dev-key"
  resource_group_name = local.azurerm_resource_group
}

resource "azurerm_virtual_network" "prozyne-dev-network" {
  name                = "prozyne-dev-network"
  location            = local.azurerm_resource_group_location
  resource_group_name = local.azurerm_resource_group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "prozyne-dev-k8s-subnet" {
  name                 = "prozyne-dev-k8s-subnet"
  resource_group_name  = local.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.prozyne-dev-network.name
  address_prefixes     = [module.subnet_addrs.network_cidr_blocks["prozyne-dev-k8s-cidr"]]
}

resource "azurerm_subnet" "prozyne-dev-vm-subnet" {
  name                 = "prozyne-dev-vm-subnet"
  resource_group_name  = local.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.prozyne-dev-network.name
  address_prefixes     = [module.subnet_addrs.network_cidr_blocks["prozyne-dev-vm-cidr"]]
}

resource "azurerm_public_ip" "prozyne-dev-pub-ip" {
  name                = "prozyne-dev-pub-ip"
  resource_group_name = local.azurerm_resource_group
  location            = local.azurerm_resource_group_location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface" "prozyne-dev-nic" {
  name                = "prozyne-dev-nic"
  resource_group_name = local.azurerm_resource_group
  location            = local.azurerm_resource_group_location

  ip_configuration {
    name                          = "prozyne-dev-nic"
    subnet_id                     = azurerm_subnet.prozyne-dev-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.prozyne-dev-pub-ip.id
  }
}

resource "azurerm_network_security_group" "prozyne-dev-pub-nsg" {
  name                = "prozyne-dev-pub-nsg"
  resource_group_name = local.azurerm_resource_group
  location            = local.azurerm_resource_group_location

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.prozyne-dev-nic.private_ip_address
 }
}

resource "azurerm_network_interface_security_group_association" "prozyne-dev-pub-nisga" {
  network_interface_id      = azurerm_network_interface.prozyne-dev-nic.id
  network_security_group_id = azurerm_network_security_group.prozyne-dev-pub-nsg.id
}

resource "azurerm_linux_virtual_machine" "prozyne-dev-vm" {
  name                = "dev-vm"
  resource_group_name = local.azurerm_resource_group
  location            = local.azurerm_resource_group_location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.prozyne-dev-nic.id,]

  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_ssh_public_key.prozyne-dev-key.public_key
  }

  os_disk {
    disk_size_gb = 50
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_kubernetes_cluster" "prozyne-dev-cluster" {
  name                = "prozyne-dev-cluster"
  resource_group_name = local.azurerm_resource_group
  location            = local.azurerm_resource_group_location
  dns_prefix          = "prozyne-dev-cluster"
  private_dns_zone_id = "System"
  private_cluster_enabled = true
  private_cluster_public_fqdn_enabled = true
  azure_policy_enabled = false
  http_application_routing_enabled = false
  oidc_issuer_enabled = false
  open_service_mesh_enabled = false
  role_based_access_control_enabled = true
  run_command_enabled = true

  linux_profile {
    admin_username = "adminuser"

    ssh_key {
      key_data = data.azurerm_ssh_public_key.prozyne-dev-key.public_key
    }
  }

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_B2s"
    os_disk_size_gb = 50
    ultra_ssd_enabled = false
    enable_auto_scaling = false
    min_count = null
    node_count = 1
    max_count = null
    max_pods = 120
  }

  network_profile {
    network_plugin = "kubenet"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "prozyne-dev-k8s-role" {
  scope                = azurerm_virtual_network.prozyne-dev-network.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.prozyne-dev-cluster.kubelet_identity[0].object_id
}