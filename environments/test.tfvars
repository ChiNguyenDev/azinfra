// terraform apply -var-file="./environments/test.tfvars"
environment_decleration = "test"

network_configuration = {
  vnet = {
    name          = "vnet1"
    address_space = ["10.0.0.0/16"]
  }
  subnet = {
    app = {
      address_prefix  = "10.0.1.0/24"
      nsg_association = "app"
    }
    web = {
      address_prefix  = "10.0.2.0/24"
      nsg_association = "web"
    }
    db = {
      address_prefix  = "10.0.3.0/24"
      nsg_association = "db"
    }
  }
  nsg = {
    app = {
      rule = {
        rdp_rule = {
          name                   = "AllowSSH"
          priority               = 100
          direction              = "Inbound"
          access                 = "Allow"
          destination_port_range = "22"
        }
        http_rule = {
          name                   = "AllowHTTP"
          priority               = 101
          direction              = "Inbound"
          access                 = "Allow"
          destination_port_range = "80"
        }
      }
    }
    web = {
      name = "web-nsg"
      rule = {
      }
    }
    db = {
      name = "db-nsg"
      rule = {
      }
    }
  }
}

keyvault_configuration = {
  name                = "testvault1999"
  resource_group_name = "vaultgroup"
  secrets = {
    vm_secret_name = "vmpassword"
    db_secret_name = "dbpassword"
  }
}

backup_configuration = {
  recovery_vault = {
    name                 = "recoveryvault"
    backup_policies_path = "./environments/test/backuppolicies"
  }
}

loadbalancer_configuration = {
  name = "loadbalancer1"
  sku = "Standard"
  frontend_ip_configuration = {
    name = "frontend-config1"
  }
  public_ip = {
    name              = "lb1-ip"
    allocation_method = "Static"
    sku = "Standard"
  }
  backendpool = {
    name = "backendpool1"
  }
  probe = {
    name = "probe1"
    port = 80
  }
  lb_rule = {
    lb_rule1 = {
      name = "lbrule1"
      frontend_port = 80
      backend_port = 80
    }
  }
}

database_configuration = {
  server = {
    administrator_login = "chi.nguyen"
    azuread_administrator = {
      login_username = "DBadmins"
      object_id = "3974702a-b203-4ee5-9d73-04336774be22"
    }
  }
}