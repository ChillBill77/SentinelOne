
resource "azurerm_monitor_action_group" "az_mon" {
  name                = "notification-monitor"
  resource_group_name = "${var.resource_group_name}"
  short_name          = "${var.prefix}-mon"
}

resource "azurerm_consumption_budget_resource_group" "az_budget" {
  name              = "${var.prefix}"
  resource_group_id = "${var.resource_group_id}"

  amount     = "${var.amount}"
  time_grain = "Monthly"
  time_period {
    start_date = "${formatdate("YYYY-MM", timestamp())}-01T00:00:00Z"
  }

  filter {
    dimension {
      name = "ResourceId"
      values = [
        azurerm_monitor_action_group.az_mon.id,
      ]
    }
  }


  notification {
    enabled        = true
    threshold      = 80.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    contact_emails = [
      "${var.notification_email}"
    ]

    contact_groups = [
      azurerm_monitor_action_group.az_mon.id,
    ]

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled   = false
    threshold = 100.0
    operator  = "GreaterThan"

    contact_emails = [
      "${var.notification_email}",
    ]
  }
}