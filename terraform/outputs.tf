output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "Workstation_public_ip_address" {
  value = azurerm_windows_virtual_machine.workstationmain.public_ip_address
}

output "Workstation_admin_user" {
  value     = azurerm_windows_virtual_machine.workstationmain.admin_username
}

output "Workstation_admin_password" {
  value     = azurerm_windows_virtual_machine.workstationmain.admin_password
  sensitive = true
}

# output "Server_public_ip_address" {
#   value = azurerm_windows_virtual_machine.servermain.public_ip_address
# }

# output "Server_admin_user" {
#   value     = azurerm_windows_virtual_machine.servermain.admin_username
# }

# output "Server_admin_password" {
#   value     = azurerm_windows_virtual_machine.servermain.admin_password
#   sensitive = true
# }