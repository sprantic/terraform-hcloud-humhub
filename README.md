# Terraform HumHub Module for Hetzner Cloud

This Terraform module creates a complete HumHub social network platform on Hetzner Cloud infrastructure with a multi-server architecture for optimal performance and scalability.

## Architecture

The module deploys a three-tier architecture:

- **Application Server**: Runs HumHub with NGINX and PHP-FPM
- **Database Server**: Dedicated MySQL server for data storage
- **Redis Server**: Provides caching and session storage
- **Private Network**: Secure communication between servers
- **Load Balancer**: Optional for high availability

## Features

- ✅ **Multi-server Architecture**: Separate application, database, and cache servers
- ✅ **Automated Installation**: Uses Ansible playbooks deployed via cloud-init
- ✅ **Security Hardened**: Firewall rules, private networking, SSL/TLS support
- ✅ **Backup System**: Automated daily backups for database and application
- ✅ **Monitoring Ready**: Optional Prometheus/Grafana integration
- ✅ **Keycloak SSO**: Prepared for single sign-on integration
- ✅ **Scalable**: Easy to adjust server sizes and add load balancing

## Quick Start

```hcl
module "humhub" {
  source = "github.com/your-org/terraform-hcloud-humhub"

  project_name = "my-humhub"
  ssh_key_name = "my-existing-ssh-key"
  
  # Optional: Configure domain and SSL
  domain_name       = "humhub.example.com"
  enable_ssl        = true
  letsencrypt_email = "admin@example.com"
}
```

## Prerequisites

### SSH Key Setup

Before using this module, you need to create an SSH key in the Hetzner Cloud Console:

1. **Generate SSH Key** (if you don't have one):
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

2. **Add SSH Key to Hetzner Cloud**:
   - Go to [Hetzner Cloud Console](https://console.hetzner.cloud/)
   - Navigate to "SSH Keys" in the sidebar
   - Click "Add SSH Key"
   - Paste your public key content (from `cat ~/.ssh/id_rsa.pub`)
   - Give it a descriptive name (e.g., "my-humhub-key")

3. **Reference the SSH Key** in your Terraform configuration:
   ```hcl
   ssh_key_name = "my-humhub-key"  # Use the name you gave it in step 2
   ```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| hcloud | ~> 1.45 |
| random | ~> 3.1 |
| archive | ~> 2.4 |

## Providers

| Name | Version |
|------|---------|
| hcloud | ~> 1.45 |
| random | ~> 3.1 |
| archive | ~> 2.4 |

## Resources Created

- 2-3x Hetzner Cloud servers (app, database, redis - or app+database combined in single server mode)
- Optional floating IPs (when enabled)
- 1x Private network with subnet
- 3x Firewall configurations
- 1x Load balancer (optional)

## Usage Examples

### Basic Deployment

```hcl
module "humhub" {
  source = "./terraform-hcloud-humhub"

  project_name = "humhub-prod"
  ssh_key_name = "my-production-key"
  
  # Server configuration
  app_server_type      = "cx21"
  database_server_type = "cx21"
  redis_server_type    = "cx11"
  
  # Security
  allowed_ssh_ips = ["203.0.113.0/24"]
}
```

### Single Server Mode (Reduced Cost)

```hcl
module "humhub" {
  source = "./terraform-hcloud-humhub"

  project_name = "humhub-small"
  ssh_key_name = "my-production-key"
  
  # Enable single server mode (app + database on same server)
  single_server_mode = true
  
  # Only need 2 servers instead of 3
  app_server_type   = "cx21"  # Runs both app and database
  redis_server_type = "cx11"  # Separate Redis server
  
  # Security
  allowed_ssh_ips = ["203.0.113.0/24"]
}
```

### With Floating IPs (Bypass Primary IP Limits)

```hcl
module "humhub" {
  source = "./terraform-hcloud-humhub"

  project_name = "humhub-prod"
  ssh_key_name = "my-production-key"
  
  # Use floating IPs to bypass Primary IP account limits
  use_floating_ips = true
  
  # Optional: Also use single server mode for even fewer IPs
  single_server_mode = true
  
  # Server configuration
  app_server_type   = "cx21"
  redis_server_type = "cx11"
}
```

### Production with SSL and Monitoring

```hcl
module "humhub" {
  source = "./terraform-hcloud-humhub"

  project_name = "humhub-prod"
  ssh_key_name = "my-production-key"
  
  # Domain and SSL
  domain_name       = "social.company.com"
  enable_ssl        = true
  letsencrypt_email = "admin@company.com"
  
  # High availability
  enable_load_balancer = true
  
  # Monitoring
  monitoring_enabled = true
  
  # Larger servers for production
  app_server_type      = "cx31"
  database_server_type = "cx31"
  redis_server_type    = "cx21"
}
```

### With Keycloak SSO

```hcl
module "humhub" {
  source = "./terraform-hcloud-humhub"

  project_name = "humhub-sso"
  ssh_key_name = "my-sso-key"
  
  # Keycloak integration
  keycloak_integration = true
  keycloak_server_url  = "https://auth.company.com"
  keycloak_realm       = "company"
  keycloak_client_id   = "humhub"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Name of the project, used as prefix for resources | `string` | `"humhub"` | no |
| ssh_key_name | Name of existing SSH key in Hetzner Cloud for server access | `string` | n/a | yes |
| server_image | Server image to use for all instances | `string` | `"ubuntu-22.04"` | no |
| server_location | Hetzner Cloud location for servers | `string` | `"nbg1"` | no |
| app_server_type | Server type for the application server | `string` | `"cx21"` | no |
| database_server_type | Server type for the database server | `string` | `"cx21"` | no |
| redis_server_type | Server type for the Redis server | `string` | `"cx11"` | no |
| domain_name | Domain name for the HumHub installation | `string` | `""` | no |
| enable_ssl | Whether to enable SSL/TLS with Let's Encrypt | `bool` | `true` | no |
| letsencrypt_email | Email address for Let's Encrypt certificate registration | `string` | `""` | no |
| humhub_version | Version of HumHub to install | `string` | `"1.15"` | no |
| enable_load_balancer | Whether to create a load balancer | `bool` | `false` | no |
| backup_enabled | Whether to enable automated backups | `bool` | `true` | no |
| monitoring_enabled | Whether to enable monitoring with Prometheus/Grafana | `bool` | `false` | no |
| keycloak_integration | Whether to prepare for Keycloak SSO integration | `bool` | `false` | no |
| single_server_mode | Deploy app and database on the same server (reduces server count from 3 to 2) | `bool` | `false` | no |
| use_floating_ips | Use floating IPs instead of primary IPs (bypasses primary IP limits, costs extra ~€1.19/month per IP) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| humhub_url | URL to access HumHub |
| app_server_ip | Public IP address of the application server |
| database_server_ip | Public IP address of the database server |
| redis_server_ip | Public IP address of the Redis server |
| load_balancer_ip | Public IP address of the load balancer (if enabled) |
| connection_info | SSH connection information for the servers |
| database_password | Generated database password (sensitive) |
| service_endpoints | Internal service endpoints |

## Post-Deployment

### Initial Setup

1. **Access HumHub**: Navigate to the output URL
2. **Complete Setup**: Follow the HumHub installation wizard
3. **Configure Community**: Set up your social network settings

### SSH Access

```bash
# Application server
ssh root@<app_server_ip>

# Database server
ssh root@<database_server_ip>

# Redis server
ssh root@<redis_server_ip>
```

### Backup Management

Automated backups are stored in `/opt/humhub-backups/` on each server:
- Database backups: Daily at 2:00 AM
- Application backups: Daily at 3:00 AM
- Redis backups: Daily at 2:30 AM

### Monitoring (if enabled)

- **Prometheus**: `http://<app_server_ip>:9090`
- **Grafana**: `http://<app_server_ip>:3000`
- **Node Exporter**: Port 9100 on all servers

## Security Considerations

- All servers use private networking for internal communication
- Firewall rules restrict access to necessary ports only
- SSH access can be limited to specific IP addresses
- SSL/TLS encryption available with Let's Encrypt
- Regular security updates via automated patching

## Cost Estimation

Approximate monthly costs (EUR):
- **Basic Setup** (3 servers: cx11 + 2x cx21): ~€20.57
- **Single Server Mode** (2 servers: cx21 + cx11): ~€13.72
- **Production Setup** (3 servers: cx21 + 2x cx31): ~€41.14
- **Production Single Server** (2 servers: cx31 + cx21): ~€27.43
- **Load Balancer**: +€5.39
- **Network Traffic**: Usually free within limits

**Note**: Single server mode reduces costs by ~33% by combining app and database on one server.

## Troubleshooting

### Common Issues

1. **Cloud-init failures**: Check `/var/log/cloud-init-output.log`
2. **Ansible errors**: Review `/opt/ansible-setup.sh` execution
3. **Service issues**: Use `systemctl status <service>`
4. **Network connectivity**: Verify firewall rules and private IPs

### Useful Commands

```bash
# Check installation progress
tail -f /var/log/cloud-init-output.log

# Verify services
systemctl status nginx php8.1-fpm mysql redis

# Check HumHub logs
tail -f /var/www/humhub/protected/runtime/logs/app.log

# Test database connection
mysql -h <db_private_ip> -u humhub -p
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## References

- [HumHub Documentation](https://docs.humhub.org/)
- [HumHub Server Setup](https://docs.humhub.org/docs/admin/server-setup)
- [HumHub Installation](https://docs.humhub.org/docs/admin/installation)
- [HumHub Requirements](https://docs.humhub.org/docs/admin/requirements)
- [Hetzner Cloud Documentation](https://docs.hetzner.cloud/)
- [Keycloak Integration](https://github.com/cuzy-app/auth-keycloak)
