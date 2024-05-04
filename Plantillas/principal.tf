# Se procede a crear la infraestructura de Terraform (backend). 
# El fichero de configuración tfstate almacenará los metadatos para crear un entorno. 
# Este entorno  se creara, modificara, actualizara y tambien cabe la posibilidad de orientarlo a destruirlo.
# Si no existe tfstate, Terraform intentará recrear toda la configuración en lugar de actualizarla.

terraform {
  backend "azurerm" {
    resource_group_name = "Grupojalg" #estos codigo ( resource_group_name, storage_account_name y container_name) 
    storage_account_name = "almacenamientojalg" # hay que crearlos antes de hacer el código
    container_name = "contenedorjose" 
    key = "terraform.tfstate"  # fichero  configuración que se va a crear 
    }
}

# Se selecciona Azure Provider y la versión que usará
terraform {
  required_version = ">= 1.8.2" # se actualiza constantemente, varias veces al mes, hay que mirar que esté correcta, puede dar problemas (esta linea se podría quitar)

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
}

# Se configura Microsoft Azure provider
provider "azurerm" { # si no se tiene permisos para registrar proveedores en azure, insertar "linea skip_provider_registration = true" entre provider y features
  features {}
}

# Se crea un grupo de recursos en caso de que no exista. La variable se hace con var. mas el grupo de recurso, haciendo referencia al fichero variable.tf
resource "azurerm_resource_group" "az_rg" {
  name     = var.ResourceGroupName  # apunta a la variable del archivo orientada.tf donde el nombre es mi-grupo-terraform
  location = var.ResourceGroupLocation # apunta a la variable del archivo orientada.tf donde la localización del grupo de recursos es oeste de europa
}

# Se crea la red virtual
resource "azurerm_virtual_network" "az_vnet" {
  name                = var.AzurermVirtualNetworkName
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = azurerm_resource_group.az_rg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Grupojalg-env" # esto es el entorno, con el nombre predefinido
  }
}

# Se crea una subred virtual
resource "azurerm_subnet" "az_subnet" {
  name                 = "Grupojalg-subnet"
  resource_group_name  = azurerm_resource_group.az_rg.name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Se crea una ip publica
resource "azurerm_public_ip" "az_public_ip" {
  name                = "Grupojalg-public-ip"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name
  allocation_method   = "Static"

  tags = {
    environment = "Grupojalg-env"
  }
}

# Se crean las reglas y los grupos de seguridad por http , localhost 8080 ( variable vamos a ejecutar  linea 182 "vas por buen camino jose" ) y ssh
resource "azurerm_network_security_group" "az_net_sec_group" {
  name                = "Grupojalg-nsg"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name

  security_rule {
    name                       = "HTTP" # nombre de la regla de seguridad
    priority                   = 1002  # tipo prioridad cuanto mas cerca al 100 más restrictiva, cuanto más alejada menos prioriza
    direction                  = "Inbound" # dirección entrante
    access                     = "Allow" # con permiso de acceso
    protocol                   = "Tcp" # tipo de protocolo en este caso tcp 
    source_port_range          = "*" # el asterisco indica que no se establece un rango en el puerto de origen
    destination_port_range     = "80" # el puerto de destino es el 80
    source_address_prefix      = "*" # el asterisco indica que no hay intervalo en el prefijo de la direccion de origen 
    destination_address_prefix = "*" # el asterisco indica que no hay intervalo en el prefijo de la direccion de destino
  }

  security_rule {
    name                       = "8080"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "${var.puerto_expuesto}" # con este parametro se indica que le dejas el puerto del nombre (8080) expuesto para su uso, por donde orientara y saldra el mensaje
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Grupojalg-env"
  }
}

# Se crea el interfaz de red
resource "azurerm_network_interface" "az_net_int" {
  name                = "Grupojalg-nic"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name

  ip_configuration {
    name                          = "Grupojalg-nic-ip-config"
    subnet_id                     = azurerm_subnet.az_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip_privada}"
    public_ip_address_id          = azurerm_public_ip.az_public_ip.id
  }

  tags = {
    environment = "Grupojalg-env"
  }
}

# Se crea la asociacion de grupo de seguridad del recurso anterior (interfaz de red)
resource "azurerm_network_interface_security_group_association" "az_net_int_sec_group" {
  network_interface_id      = azurerm_network_interface.az_net_int.id
  network_security_group_id = azurerm_network_security_group.az_net_sec_group.id
}

# Crear máquina virtual
resource "azurerm_linux_virtual_machine" "az_linux_vm" {
  name                            = "Grupojalg-maquina"
  location                        = azurerm_resource_group.az_rg.location
  resource_group_name             = azurerm_resource_group.az_rg.name
  network_interface_ids           = [azurerm_network_interface.az_net_int.id]
  size                            = "${var.size}" # credenciales de la máquina size azure (recursos) standard_d2_v2 nombre dv2-series azure nombre size
  computer_name                   = "${var.hostname}"
  admin_username                  = "${var.usuario}"
  admin_password                  = "${var.contrasena}"
  disable_password_authentication = false

  source_image_reference {  # fuente de la imagen de referencia 
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_disk {  # se crea disco del sistema operativo
    name                 = "Grupojalg-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  
  tags = {
    environment = "Grupojalg-env"
  }
}

# Configurar la ejecución de tareas automáticamente al iniciar la MV.

resource "azurerm_virtual_machine_extension" "az_vm_extension" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.az_linux_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

# Se crean ajustes y aquí se le esta diciendo que haga el echo de la salida de la variable 
# en el fichero orientada.tf y arroje por el puerto expuesto 8080 el mensaje que pongamos

  settings = <<SETTINGS
    {
      "commandToExecute": "echo '${var.salida_echo}' > index.html ; nohup busybox httpd -f -p ${var.puerto_expuesto} &" 
    }
  SETTINGS 

  tags = {
    environment = "Grupojalg-env"
  }
}

# Es la fuente de datos para acceder a las propiedades de una dirección IP pública de Azure existente.
data "azurerm_public_ip" "az_public_ip" { #asociacion de la ip publica con la maquina con el grupo de recursos
  name                = azurerm_public_ip.az_public_ip.name
  resource_group_name = azurerm_linux_virtual_machine.az_linux_vm.resource_group_name
}

# Es la variable de salida: Dirección de IP pública output de la ip, para que cuando termine la ejecucion de la pipeline se muestre por pantalla la ip publica, por si se va a ejecutar en local desde terraform, no es necesario
output "public_ip" {
  value = data.azurerm_public_ip.az_public_ip.ip_address
}