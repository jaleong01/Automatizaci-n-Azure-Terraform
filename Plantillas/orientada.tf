#En este fichero se declaran las variables indicando tipo (type) cadena (string) que sería el nombre de la variable y una descripción

variable StorageAccountName {
    type = string
    default = "storage01" 
    description= "Nombre para la cuenta de almacenamiento"  
}

variable ResourceGroupName {
    type = string 
    default = "my-terraform-rg" 
    description= "Nombre del grupo de recursos"  
}

variable ResourceGroupLocation {
    type = string 
    default = "West Europe" 
    description= "Región donde reside el grupo de recursos"  
}

variable AzurermVirtualNetworkName {
    type = string
    default = "my-terraform-vnet"
    description= "Nombre para la red virtual de Azure"  
}

# Configuración VM , parametro sensitive, no se muestre por pantalla las credenciales del usuario y contraseña en la ejecución de la pipeline

variable usuario {
    type = string 
    default = "alfonso" # usuario de la maquina virtual
    sensitive = true 
}

variable contrasena {
    type = string 
    default = "Usuario1!" # contraseña de la maquina virtual
    sensitive = true
}

variable hostname {
    type = string 
    default = "myvm" 
}

variable ip_privada {
  type = string
  default = "10.0.2.5"
}

variable size {
    type = string
    default = "Standard_DS1_v2"
}

# Variables httpd

variable puerto_expuesto {
  type = string
  default = "8080"
}

variable salida_echo {
  type = string
  default = "Vas por buen camino Jose"
}