# code: language=terraform
resource "random_pet" "prefix" {
  length = 1
}

resource "random_integer" "number" {
  min = 21
  max = 9999
}

resource "random_password" "password" {
  length      = 27
  min_lower   = 8
  min_upper   = 3
  min_numeric = 4
  min_special = 1
  special     = true
}

resource "azurerm_resource_group" "rg" {
  location            = var.resource_group_location
  #name                = "${var.prefix}-demo-${var.demo_name}-rg-${local.current_datetime}"
  name                = "${var.prefix}-demo-${var.demo_name}-rg"
  tags                = local.common_tags
  
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "global-${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

##Workstation
# Create subnet
resource "azurerm_subnet" "my_terraform_workstation_subnet" {
  name                 = "${random_pet.prefix.id}-workstation-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP #1
resource "azurerm_public_ip" "my_terraform_public_ip1" {
  name                 = "workstation-${random_pet.prefix.id}-public-ip1"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  allocation_method    = "Dynamic"
  tags                 = local.common_tags
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_workstationnic" {
  name                = "workstation-${random_pet.prefix.id}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_workstation_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip1.id
  }
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_workstationnsg" {
  name                = "workstation-${random_pet.prefix.id}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_workstationnic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_workstationnsg.id
}


# Create virtual machines
resource "azurerm_windows_virtual_machine" "workstationmain" {
  name                  = "wks-${random_pet.prefix.id}-vm"
  admin_username        = "${var.demo_name}-admin${random_integer.number.result}"
  admin_password        = random_password.password.result
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_workstationnic.id]
  #size                  = "Standard_F4s_v2" #Performance
  size                  = "Standard_DS2_v2" #Standard
  tags                  = local.common_tags
  timeouts {
    create = "15m"
    delete = "15m"
  }

  os_disk {
    name                 = "workstation-${random_pet.prefix.id}-OSdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows11preview"
    sku       = "win11-22h2-ent-cpc-m365"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "Fallback" {
  name                 = "Fallback"
  virtual_machine_id   = azurerm_windows_virtual_machine.workstationmain.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on           = [azurerm_windows_virtual_machine.workstationmain]
  timeouts {
    create = "15m"
    delete = "15m"
  }
  settings = <<SETTINGS
 {
    "fileUris": [ "https://raw.githubusercontent.com/ChillBill77/SentinelOne/main/setup.ps1" ],
    "commandToExecute": "powershell.exe -Command Copy-Item setup.ps1 -Destination C:/Users/Public/Desktop "
 }
SETTINGS
}

module "notification" {
  source = "./modules/notification"
  resource_group_id           = "${azurerm_resource_group.rg.id}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  notification_email          = "${var.requestor_email}"
  prefix                      = "${random_pet.prefix.id}"
  amount                      = "10"
  depends_on                  = [azurerm_windows_virtual_machine.workstationmain]
}
