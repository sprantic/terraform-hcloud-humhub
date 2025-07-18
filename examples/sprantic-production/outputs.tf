output "humhub_url" {
  description = "URL to access HumHub"
  value       = module.humhub_sprantic.humhub_url
}

output "app_server_ip" {
  description = "Public IP address of the application server"
  value       = module.humhub_sprantic.app_server_ip
}

output "database_server_ip" {
  description = "Public IP address of the database server"
  value       = module.humhub_sprantic.database_server_ip
}

output "redis_server_ip" {
  description = "Public IP address of the Redis server"
  value       = module.humhub_sprantic.redis_server_ip
}

output "connection_info" {
  description = "SSH connection information for the servers"
  value       = module.humhub_sprantic.connection_info
}

output "database_password" {
  description = "Generated database password"
  value       = module.humhub_sprantic.database_password
  sensitive   = true
}

output "dns_configuration" {
  description = "DNS configuration required"
  value = {
    domain = "humhub.sprantic.ai"
    type   = "A"
    value  = module.humhub_sprantic.app_server_ip
    ttl    = 300
  }
}

output "ssl_status" {
  description = "SSL certificate information"
  value = {
    enabled = true
    domain  = "humhub.sprantic.ai"
    issuer  = "Let's Encrypt"
    email   = "admin@sprantic.ai"
  }
}

output "monitoring_endpoints" {
  description = "Monitoring endpoints (if enabled)"
  value = {
    prometheus = "http://${module.humhub_sprantic.app_server_ip}:9090"
    grafana    = "http://${module.humhub_sprantic.app_server_ip}:3000"
  }
}