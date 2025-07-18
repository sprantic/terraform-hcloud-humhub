output "humhub_url" {
  description = "URL to access HumHub"
  value       = module.humhub.humhub_url
}

output "app_server_ip" {
  description = "Public IP address of the application server"
  value       = module.humhub.app_server_ip
}

output "database_server_ip" {
  description = "Public IP address of the database server"
  value       = module.humhub.database_server_ip
}

output "redis_server_ip" {
  description = "Public IP address of the Redis server"
  value       = module.humhub.redis_server_ip
}

output "load_balancer_ip" {
  description = "Public IP address of the load balancer (if enabled)"
  value       = module.humhub.load_balancer_ip
}

output "connection_info" {
  description = "SSH connection information for the servers"
  value       = module.humhub.connection_info
}

output "database_password" {
  description = "Generated database password"
  value       = module.humhub.database_password
  sensitive   = true
}

output "service_endpoints" {
  description = "Internal service endpoints"
  value       = module.humhub.service_endpoints
}

output "backup_info" {
  description = "Backup configuration information"
  value       = module.humhub.backup_info
}

output "monitoring_info" {
  description = "Monitoring configuration information"
  value       = module.humhub.monitoring_info
}

output "keycloak_integration_info" {
  description = "Keycloak integration configuration"
  value       = module.humhub.keycloak_integration_info
}