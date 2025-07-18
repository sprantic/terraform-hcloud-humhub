variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Name of the project, used as prefix for resources"
  type        = string
  default     = "humhub-example"
}

variable "ssh_key_name" {
  description = "Name of existing SSH key in Hetzner Cloud for server access"
  type        = string
}

variable "server_location" {
  description = "Hetzner Cloud location for servers"
  type        = string
  default     = "nbg1"
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

variable "domain_name" {
  description = "Domain name for the HumHub installation (optional)"
  type        = string
  default     = ""
}

variable "enable_ssl" {
  description = "Whether to enable SSL/TLS with Let's Encrypt"
  type        = bool
  default     = false
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt certificate registration"
  type        = string
  default     = ""
}

variable "humhub_version" {
  description = "Version of HumHub to install"
  type        = string
  default     = "1.15"
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

variable "allowed_ssh_ips" {
  description = "List of IP addresses allowed to SSH to servers"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_load_balancer" {
  description = "Whether to create a load balancer"
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = true
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
  default = {
    Environment = "example"
    Project     = "humhub"
  }
}