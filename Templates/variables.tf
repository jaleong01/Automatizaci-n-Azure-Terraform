#En este fichero se declaran las variables indicando tipo (type) cadena (string) que sería el nombre de la variable con comando default y una descripción

variable StorageAccountName {
    type = string
    default = "almacenamientojalg" 
    description= "Nombre cuenta de almacenamiento"  
}

variable ResourceGroupName {
    type = string 
    default = "Grupojalg" 
    description= "Nombre del grupo de recursos"  
}

variable ResourceGroupLocation {
    type = string 
    default = "West Europe" 
    description= "Región geográfica del grupo de recursos"  
}

variable AzurermVirtualNetworkName {
    type = string
    default = "Grupojalg-vnet"
    description= "Nombre red virtual de Azure"  
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
  default = "10.0.2.6" #ip de la red privada que hemos establecido dentro del rango de ip que le dimos en el archivo principal (main)
}

variable size {
    type = string
    default = "Standard_B1s" # si no funciona version de tamaño (Standard_d2_v2), modificar por Standard_B1s tiene gratuitas hasta 750 horas
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
