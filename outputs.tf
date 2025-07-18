output "app_server_ip" {
  description = "Public IP address of the application server"
  value       = hcloud_server.app.ipv4_address
}

output "app_server_private_ip" {
  description = "Private IP address of the application server"
  value       = var.app_private_ip
}

output "database_server_ip" {
  description = "Public IP address of the database server (private-only, null in single server mode)"
  value       = null
}

output "database_server_private_ip" {
  description = "Private IP address of the database server (app server IP in single server mode)"
  value       = var.single_server_mode ? var.app_private_ip : var.database_private_ip
}

output "redis_server_ip" {
  description = "Public IP address of the Redis server (private-only)"
  value       = null
}

output "redis_server_private_ip" {
  description = "Private IP address of the Redis server"
  value       = var.redis_private_ip
}

output "load_balancer_ip" {
  description = "Public IP address of the load balancer (if enabled)"
  value       = var.enable_load_balancer ? hcloud_load_balancer.humhub_lb[0].ipv4 : null
}

output "network_id" {
  description = "ID of the created network"
  value       = hcloud_network.humhub_network.id
}

output "network_cidr" {
  description = "CIDR block of the created network"
  value       = hcloud_network.humhub_network.ip_range
}

output "ssh_key_id" {
  description = "ID of the SSH key"
  value       = data.hcloud_ssh_key.humhub_key.id
}

output "database_password" {
  description = "Generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "humhub_url" {
  description = "URL to access HumHub"
  value       = var.domain_name != "" ? (var.enable_ssl ? "https://${var.domain_name}" : "http://${var.domain_name}") : (var.enable_ssl ? "https://${hcloud_server.app.ipv4_address}" : "http://${hcloud_server.app.ipv4_address}")
}

output "server_ids" {
  description = "Map of server IDs"
  value = {
    app      = hcloud_server.app.id
    database = var.single_server_mode ? null : hcloud_server.database[0].id
    redis    = hcloud_server.redis.id
  }
}

output "firewall_ids" {
  description = "Map of firewall IDs"
  value = {
    web      = hcloud_firewall.web_firewall.id
    database = hcloud_firewall.database_firewall.id
    redis    = hcloud_firewall.redis_firewall.id
  }
}

output "connection_info" {
  description = "Connection information for the servers"
  value = {
    app_ssh      = "ssh root@${hcloud_server.app.ipv4_address}"
    database_ssh = var.single_server_mode ? "ssh root@${hcloud_server.app.ipv4_address} (same as app)" : "ssh via app server (private-only)"
    redis_ssh    = "ssh via app server (private-only)"
  }
}

output "service_endpoints" {
  description = "Internal service endpoints"
  value = {
    mysql_host = var.single_server_mode ? var.app_private_ip : var.database_private_ip
    mysql_port = 3306
    redis_host = var.redis_private_ip
    redis_port = 6379
  }
  sensitive = false
}

output "backup_info" {
  description = "Backup configuration information"
  value = var.backup_enabled ? {
    enabled         = true
    retention_days  = var.backup_retention_days
    backup_location = "/opt/humhub-backups"
  } : {
    enabled = false
  }
}

output "monitoring_info" {
  description = "Monitoring configuration information"
  value = var.monitoring_enabled ? {
    enabled            = true
    prometheus_port    = 9090
    grafana_port       = 3000
    node_exporter_port = 9100
  } : {
    enabled            = false
    prometheus_port    = null
    grafana_port       = null
    node_exporter_port = null
  }
}

output "keycloak_integration_info" {
  description = "Keycloak integration configuration"
  value = var.keycloak_integration ? {
    enabled     = true
    server_url  = var.keycloak_server_url
    realm       = var.keycloak_realm
    client_id   = var.keycloak_client_id
  } : {
    enabled = false
  }
  sensitive = false
}
