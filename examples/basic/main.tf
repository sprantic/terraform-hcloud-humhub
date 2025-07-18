terraform {
  required_version = ">= 1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

# Use the HumHub module
module "humhub" {
  source = "../../"

  # Basic configuration
  project_name   = var.project_name
  ssh_key_name = var.ssh_key_name

  # Server configuration
  server_location        = var.server_location
  app_server_type        = var.app_server_type
  database_server_type   = var.database_server_type
  redis_server_type      = var.redis_server_type

  # Network configuration
  network_cidr = var.network_cidr
  subnet_cidr  = var.subnet_cidr

  # Domain and SSL
  domain_name       = var.domain_name
  enable_ssl        = var.enable_ssl
  letsencrypt_email = var.letsencrypt_email

  # HumHub configuration
  humhub_version        = var.humhub_version
  humhub_admin_email    = var.humhub_admin_email
  humhub_admin_username = var.humhub_admin_username
  humhub_admin_password = var.humhub_admin_password

  # Security
  allowed_ssh_ips = var.allowed_ssh_ips

  # Optional features
  enable_load_balancer = var.enable_load_balancer
  backup_enabled       = var.backup_enabled
  monitoring_enabled   = var.monitoring_enabled

  # Keycloak integration (optional)
  keycloak_integration = var.keycloak_integration
  keycloak_server_url  = var.keycloak_server_url
  keycloak_realm       = var.keycloak_realm
  keycloak_client_id   = var.keycloak_client_id

  tags = var.tags
}