terraform {
  required_version = ">= 1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

# Package Ansible playbooks
data "archive_file" "ansible_package" {
  type        = "zip"
  source_dir  = "${path.module}/ansible"
  output_path = "${path.module}/packaged/humhub-ansible.zip"
}

# Base64 encode the Ansible package for cloud-init
locals {
  ansible_zip_base64 = data.archive_file.ansible_package.output_path != "" ? filebase64(data.archive_file.ansible_package.output_path) : ""
}

# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Reference existing SSH key
data "hcloud_ssh_key" "humhub_key" {
  name = var.ssh_key_name
}

# Network for HumHub infrastructure
resource "hcloud_network" "humhub_network" {
  name     = "${var.project_name}-network"
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "humhub_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.humhub_network.id
  network_zone = var.network_zone
  ip_range     = var.subnet_cidr
}


# Firewall rules
resource "hcloud_firewall" "web_firewall" {
  name = "${var.project_name}-web-fw"

  rule {
    direction = "in"
    port      = "22"
    protocol  = "tcp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction = "in"
    port      = "80"
    protocol  = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    port      = "443"
    protocol  = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "database_firewall" {
  name = "${var.project_name}-db-fw"

  rule {
    direction = "in"
    port      = "22"
    protocol  = "tcp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction = "in"
    port      = "3306"
    protocol  = "tcp"
    source_ips = [var.subnet_cidr]
  }
}

resource "hcloud_firewall" "redis_firewall" {
  name = "${var.project_name}-redis-fw"

  rule {
    direction = "in"
    port      = "22"
    protocol  = "tcp"
    source_ips = var.allowed_ssh_ips
  }

  rule {
    direction = "in"
    port      = "6379"
    protocol  = "tcp"
    source_ips = [var.subnet_cidr]
  }
}

# Database Server (only created when not in single server mode)
resource "hcloud_server" "database" {
  count       = var.single_server_mode ? 0 : 1
  name        = "${var.project_name}-database"
  image       = var.server_image
  server_type = var.database_server_type
  location    = var.server_location
  ssh_keys    = [data.hcloud_ssh_key.humhub_key.id]
  firewall_ids = [hcloud_firewall.database_firewall.id]
  
  # Private-only server (no public IP needed)
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.humhub_network.id
    ip         = var.database_private_ip
  }

  user_data = templatefile("${path.module}/cloud-init/database.yml", {
    db_password                   = random_password.db_password.result
    mysql_innodb_buffer_pool_size = var.mysql_innodb_buffer_pool_size
    ansible_zip_content           = local.ansible_zip_base64
  })

  depends_on = [hcloud_network_subnet.humhub_subnet]
}

# Redis Server
resource "hcloud_server" "redis" {
  name         = "${var.project_name}-redis"
  image        = var.server_image
  server_type  = var.redis_server_type
  location     = var.server_location
  ssh_keys     = [data.hcloud_ssh_key.humhub_key.id]
  firewall_ids = [hcloud_firewall.redis_firewall.id]
  
  # Private-only server (no public IP needed)
  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.humhub_network.id
    ip         = var.redis_private_ip
  }


  depends_on = [hcloud_network_subnet.humhub_subnet]
}

# Application Server (includes database when in single server mode)
resource "hcloud_server" "app" {
  name        = "${var.project_name}-app"
  image       = var.server_image
  server_type = var.app_server_type
  location    = var.server_location
  ssh_keys    = [data.hcloud_ssh_key.humhub_key.id]
  firewall_ids = var.single_server_mode ? [hcloud_firewall.web_firewall.id, hcloud_firewall.database_firewall.id] : [hcloud_firewall.web_firewall.id]

  network {
    network_id = hcloud_network.humhub_network.id
    ip         = var.app_private_ip
  }

  user_data = var.single_server_mode ? templatefile("${path.module}/cloud-init/app-database.yml", {
    db_password                   = random_password.db_password.result
    mysql_innodb_buffer_pool_size = var.mysql_innodb_buffer_pool_size
    redis_host                    = var.redis_private_ip
    domain_name                   = var.domain_name
    php_version                   = var.php_version
    humhub_version                = var.humhub_version
    nginx_worker_processes        = var.nginx_worker_processes
    humhub_admin_email            = var.humhub_admin_email
    humhub_admin_username         = var.humhub_admin_username
    humhub_admin_password         = var.humhub_admin_password != "" ? var.humhub_admin_password : random_password.db_password.result
    enable_ssl                    = var.enable_ssl
    letsencrypt_email             = var.letsencrypt_email
    keycloak_integration          = var.keycloak_integration
    keycloak_server_url           = var.keycloak_server_url
    keycloak_realm                = var.keycloak_realm
    keycloak_client_id            = var.keycloak_client_id
    ansible_zip_content           = local.ansible_zip_base64
  }) : templatefile("${path.module}/cloud-init/app.yml", {
    db_host                = var.database_private_ip
    db_password            = random_password.db_password.result
    redis_host             = var.redis_private_ip
    domain_name            = var.domain_name
    php_version            = var.php_version
    humhub_version         = var.humhub_version
    nginx_worker_processes = var.nginx_worker_processes
    humhub_admin_email     = var.humhub_admin_email
    humhub_admin_username  = var.humhub_admin_username
    humhub_admin_password  = var.humhub_admin_password != "" ? var.humhub_admin_password : random_password.db_password.result
    enable_ssl             = var.enable_ssl
    letsencrypt_email      = var.letsencrypt_email
    keycloak_integration   = var.keycloak_integration
    keycloak_server_url    = var.keycloak_server_url
    keycloak_realm         = var.keycloak_realm
    keycloak_client_id     = var.keycloak_client_id
    ansible_zip_content    = local.ansible_zip_base64
  })

  depends_on = [
    hcloud_network_subnet.humhub_subnet,
    hcloud_server.database,
    hcloud_server.redis
  ]
}

# Load Balancer (optional)
resource "hcloud_load_balancer" "humhub_lb" {
  count              = var.enable_load_balancer ? 1 : 0
  name               = "${var.project_name}-lb"
  load_balancer_type = var.load_balancer_type
  location           = var.server_location
}

# Load Balancer Target
resource "hcloud_load_balancer_target" "humhub_lb_target" {
  count           = var.enable_load_balancer ? 1 : 0
  type            = "server"
  load_balancer_id = hcloud_load_balancer.humhub_lb[0].id
  server_id       = hcloud_server.app.id
}

# Load Balancer Service for HTTP
resource "hcloud_load_balancer_service" "humhub_lb_http" {
  count           = var.enable_load_balancer ? 1 : 0
  load_balancer_id = hcloud_load_balancer.humhub_lb[0].id
  protocol        = "http"
  listen_port     = 80
  destination_port = 80
}

# Load Balancer Service for HTTPS
resource "hcloud_load_balancer_service" "humhub_lb_https" {
  count           = var.enable_load_balancer ? 1 : 0
  load_balancer_id = hcloud_load_balancer.humhub_lb[0].id
  protocol        = "tcp"
  listen_port     = 443
  destination_port = 443
}
