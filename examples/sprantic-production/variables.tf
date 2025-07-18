variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of existing SSH key in Hetzner Cloud for server access"
  type        = string
}

variable "humhub_admin_password" {
  description = "Password for the HumHub admin user"
  type        = string
  sensitive   = true
}

variable "allowed_ssh_ips" {
  description = "List of IP addresses allowed to SSH to servers"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Restrict this to your office/home IP for security
}