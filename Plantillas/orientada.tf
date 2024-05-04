#En este fichero se declaran las variables indicando tipo (type) cadena (string) que sería el nombre de la variable con comando default y una descripción

variable StorageAccountName {
    type = string
    default = "almacenamientojalg" 
    description= "Nombre para la cuenta de almacenamiento"  
}

variable ResourceGroupName {
    type = string 
    default = "Grupojalg" 
    description= "Nombre del grupo de recursos"  
}

variable ResourceGroupLocation {
    type = string 
    default = "West Europe" 
    description= "Región donde reside el grupo de recursos"  
}

variable AzurermVirtualNetworkName {
    type = string
    default = "Grupojalg-vnet"
    description= "Nombre para la red virtual de Azure"  
}

# Se configura de la maquina virtual

variable usuario {
    type = string 
    default = "jose" # usuario de la maquina virtual
    sensitive = true 
}

variable contrasena {
    type = string 
    default = "F0m3nt0josefoc" # contraseña de la maquina virtual
    sensitive = true # este parametro, no se muestre por pantalla las credenciales del usuario y contraseña en la ejecución de la pipeline
}

variable hostname {
    type = string 
    default = "maquina" 
}

variable ip_privada {
  type = string
  default = "10.1.1.4"
}

variable size {
    type = string
    default = "Standard_d2_v2" # si no funciona esta version de tamaño, modificar por Standard_B1s tiene gratuitas hasta 750 horas
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