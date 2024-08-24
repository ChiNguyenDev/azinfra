resource "azurerm_recovery_services_vault" "recovery_vault" {
  name                = var.naming.recovery_services_vault.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.configuration.recovery_vault.sku
  soft_delete_enabled = var.configuration.recovery_vault.soft_delete_enabled
}


resource "azurerm_backup_policy_vm" "backup_policy" {
  for_each            = var.backup_policy
  name                = each.key
  resource_group_name = var.resource_group
  recovery_vault_name = azurerm_recovery_services_vault.recovery_vault.name
  timezone            = each.value.timezone

  backup {
    frequency = each.value.backup.frequency
    time      = each.value.backup.time
    weekdays =  each.value.backup.weekdays
  }

// dynamic blocks: only create retention configurations, if they get created
dynamic "retention_daily" {
    for_each = each.value.retention_daily != null ? [each.value.retention_daily] : []
    content {
      count = retention_daily.value.count
    }
  }

  dynamic "retention_weekly" {
    for_each = each.value.retention_weekly != null ? [each.value.retention_weekly] : []
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = each.value.retention_monthly != null ? [each.value.retention_monthly] : []
    content {
      count    = retention_monthly.value.count
      weekdays = retention_monthly.value.weekdays
      weeks    = retention_monthly.value.weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = each.value.retention_yearly != null ? [each.value.retention_yearly] : []
    content {
      count    = retention_yearly.value.count
      weekdays = retention_yearly.value.weekdays
      weeks    = retention_yearly.value.weeks
      months   = retention_yearly.value.months
    }
  }
}

resource "azurerm_backup_protected_vm" "vm" {
  for_each = {for vm, vm_config in var.vm_reference:
    vm => vm_config
    if vm_config.backup_policy_name != null
  }
  resource_group_name = var.resource_group
  recovery_vault_name = azurerm_recovery_services_vault.recovery_vault.name
  source_vm_id        = each.value.id
  backup_policy_id    = azurerm_backup_policy_vm.backup_policy[each.value.backup_policy_name].id
  lifecycle {
    prevent_destroy = false
  }
}