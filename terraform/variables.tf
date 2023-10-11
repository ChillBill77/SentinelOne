variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

#List of supported Azure Locations: 
#australiacentral,australiacentral2,australiaeast,australiasoutheast,brazilsouth,brazilsoutheast,brazilus,canadacentral,canadaeast,centralindia,centralus,centraluseuap,eastasia,eastus,eastus2,eastus2euap,francecentral,francesouth,germanynorth,germanywestcentral,israelcentral,italynorth,japaneast,japanwest,jioindiacentral,jioindiawest,koreacentral,koreasouth,malaysiasouth,northcentralus,northeurope,norwayeast,norwaywest,polandcentral,qatarcentral,southafricanorth,southafricawest,southcentralus,southeastasia,southindia,swedencentral,swedensouth,switzerlandnorth,switzerlandwest,uaecentral,uaenorth,uksouth,ukwest,westcentralus,westeurope,westindia,westus,westus2,westus3,austriaeast,chilecentral,eastusslv,israelnorthwest,malaysiawest,mexicocentral,newzealandnorth,southeastasiafoundational,spaincentral,taiwannorth,taiwannorthwest

variable "prefix" {
  type        = string
  description = "Initials of the requester"
}
variable "demo_name" {
  type        = string
  description = "Name of the Demo or Customer"
}
variable "requestor_email" {
  type        = string
  description = "Email of the requester"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    email               = var.requestor_email
    script_owner        = "Gilles van Heijst"
    requested_date      = formatdate("YYYYMMDDHHmm", timestamp())
    }

  current_datetime      = formatdate("YYYYMMDDHHmm", timestamp())
  }

