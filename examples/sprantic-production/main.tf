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

# Deploy HumHub for Sprantic with SSL
module "humhub_sprantic" {
  source = "../../"

  # Project configuration
  project_name   = "humhub-sprantic"
  ssh_key_name = var.ssh_key_name

  # Server configuration - Production sizing
  server_location        = "nbg1"  # Nuremberg, Germany
  app_server_type        = "cpx31"  # 2 vCPUs, 8 GB RAM
  database_server_type   = "cpx31"  # 2 vCPUs, 8 GB RAM
  redis_server_type      = "cpx21"  # 2 vCPUs, 4 GB RAM

  # Network configuration
  network_cidr = "10.0.0.0/16"
  subnet_cidr  = "10.0.1.0/24"

  # Domain and SSL configuration
  domain_name       = "humhub.sprantic.ai"
  enable_ssl        = true
  letsencrypt_email = "admin@sprantic.ai"

  # HumHub configuration
  humhub_version        = "1.15"
  humhub_admin_email    = "admin@sprantic.ai"
  humhub_admin_username = "admin"
  humhub_admin_password = var.humhub_admin_password

  # Security - Restrict SSH access
  allowed_ssh_ips = var.allowed_ssh_ips

  # Production features
  enable_load_balancer = false  # Can be enabled later for scaling
  backup_enabled       = true
  monitoring_enabled   = true

  # Performance tuning
  php_version                   = "8.1"
  nginx_worker_processes        = 4
  mysql_innodb_buffer_pool_size = "512M"
  redis_maxmemory              = "512mb"

  # Future Keycloak integration
  keycloak_integration = false  # Enable when ready

  # Use single server mode to reduce server count and avoid IP limits
  single_server_mode = true
  
  # Note: Database and Redis servers are private-only by default (no public IPs)
  # Only the app server needs a public IP for web access

  tags = {
    Environment = "production"
    Project     = "humhub-sprantic"
    Domain      = "humhub.sprantic.ai"
    Owner       = "sprantic"
  }
}