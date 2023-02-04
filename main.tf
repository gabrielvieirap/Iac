
##selecionando o provedor da azure para executar a declaracao do TF
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }
  }
}

provider "azurerm" {
  features {}
}
##criando o RG
resource "azurerm_resource_group" "default" {
  name     = "rg-bancos-iac-sql-stg"
  location = "eastus"
  tags = { 
    "env" ="stg"
    "project" ="bancos-de-dados-sql"
  }
}
##criando a vnet
resource "azurerm_virtual_network" "default" {
  name                = "network-intenal"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
  ##dns_servers         = ["10.0.0.4", "10.0.0.5"]
##criando subnet1
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
##criando a subinet2
  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    ##security_group = azurerm_network_security_group.example.id
  }

  tags = {
    env = "stg"
    project ="banco-de-dados-sql"
  }
}
##criando o servidor de bando postgree
resource "azurerm_postgresql_server" "default" {
  name                = "postgresql-server-stg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement_enabled      = true

  tags = {
    "env" = "stg"
    "projeto" = "sql-banco-iac"
  }
}
