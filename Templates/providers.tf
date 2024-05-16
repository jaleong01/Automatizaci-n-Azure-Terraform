# Se selecciona Azure Provider y la versión que usará
# required_version = ">= 1.7.5" # se actualiza constantemente, varias veces al mes, hay que mirar que esté correcta,
# puede dar problemas, versiones gratis haciendo pruebas he llegado a esta.
# required_providers 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # fuente de proveedor de terraform y su version
      version = "~> 2.99.0"    
    }
  }
  backend "azurerm" {
     resource_group_name = "Grupojalg" # Estos parametros en azure ( resource_group_name, storage_account_name y container_name) 
     storage_account_name = "almacenamientojalg" # hay que crearlos antes de hacer el codigo, por que induce conflicto
     container_name = "contenedorjose" 
     key = "terraform.tfstate"  # fichero  configuracion que se va a crear 
  }
}

# Se configura Microsoft Azure provider
provider "azurerm" { # si no se tiene permisos para registrar proveedores en azure, insertar "linea skip_provider_registration = true" o dar roles en el grupo
  skip_provider_registration = true  # si da error esta linea quitar por problemas de registro skip_provider_registration = true 
  features {}
}
