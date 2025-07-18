variable "project_name" {
  description = "Name of the project, used as prefix for resources"
  type        = string
  default     = "humhub"
}

variable "ssh_key_name" {
  description = "Name of existing SSH key in Hetzner Cloud for server access"
  type        = string
}

variable "server_image" {
  description = "Server image to use for all instances"
  type        = string
  default     = "ubuntu-22.04"
}

variable "server_location" {
  description = "Hetzner Cloud location for servers"
  type        = string
  default     = "nbg1"
}

variable "network_zone" {
  description = "Network zone for the subnet"
  type        = string
  default     = "eu-central"
}

variable "network_cidr" {
  description = "CIDR block for the private network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_server_type" {
  description = "Server type for the application server"
  type        = string
  default     = "cx21"
}

variable "database_server_type" {
  description = "Server type for the database server"
  type        = string
  default     = "cx21"
}

variable "redis_server_type" {
  description = "Server type for the Redis server"
  type        = string
  default     = "cx11"
}

variable "app_private_ip" {
  description = "Private IP address for the application server"
  type        = string
  default     = "10.0.1.10"
}

variable "database_private_ip" {
  description = "Private IP address for the database server"
  type        = string
  default     = "10.0.1.20"
}

variable "redis_private_ip" {
  description = "Private IP address for the Redis server"
  type        = string
  default     = "10.0.1.30"
}

variable "allowed_ssh_ips" {
  description = "List of IP addresses allowed to SSH to servers"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "domain_name" {
  description = "Domain name for the HumHub installation"
  type        = string
  default     = ""
}

variable "enable_load_balancer" {
  description = "Whether to create a load balancer"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer to create"
  type        = string
  default     = "lb11"
}

variable "humhub_version" {
  description = "Version of HumHub to install"
  type        = string
  default     = "1.15"
}

variable "mysql_root_password" {
  description = "MySQL root password (if not provided, will be auto-generated)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "humhub_admin_email" {
  description = "Email address for the HumHub admin user"
  type        = string
  default     = "admin@example.com"
}

variable "humhub_admin_username" {
  description = "Username for the HumHub admin user"
  type        = string
  default     = "admin"
}

variable "humhub_admin_password" {
  description = "Password for the HumHub admin user"
  type        = string
  default     = ""
  sensitive   = true
}

variable "enable_ssl" {
  description = "Whether to enable SSL/TLS with Let's Encrypt"
  type        = bool
  default     = true
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt certificate registration"
  type        = string
  default     = ""
}

variable "php_version" {
  description = "PHP version to install"
  type        = string
  default     = "8.1"
}

variable "nginx_worker_processes" {
  description = "Number of NGINX worker processes"
  type        = number
  default     = 2
}

variable "mysql_innodb_buffer_pool_size" {
  description = "MySQL InnoDB buffer pool size"
  type        = string
  default     = "256M"
}

variable "redis_maxmemory" {
  description = "Redis maximum memory usage"
  type        = string
  default     = "256mb"
}

variable "backup_enabled" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "monitoring_enabled" {
  description = "Whether to enable monitoring with Prometheus/Grafana"
  type        = bool
  default     = false
}

variable "keycloak_integration" {
  description = "Whether to prepare for Keycloak SSO integration"
  type        = bool
  default     = false
}

variable "keycloak_server_url" {
  description = "Keycloak server URL for SSO integration"
  type        = string
  default     = ""
}

variable "keycloak_realm" {
  description = "Keycloak realm for SSO integration"
  type        = string
  default     = "humhub"
}

variable "keycloak_client_id" {
  description = "Keycloak client ID for SSO integration"
  type        = string
  default     = "humhub"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "single_server_mode" {
  description = "Deploy app and database on the same server (reduces server count from 3 to 2)"
  type        = bool
  default     = false
}

variable "use_floating_ips" {
  description = "Use floating IPs instead of primary IPs (bypasses primary IP limits, costs extra ~€1.19/month per IP)"
  type        = bool
  default     = false
}