# HumHub Terraform Module - Basic Example

This example demonstrates how to deploy a basic HumHub installation on Hetzner Cloud using the terraform-hcloud-humhub module.

## Architecture

This example creates:
- **Application Server**: Runs HumHub with NGINX and PHP-FPM
- **Database Server**: Runs MySQL for HumHub data storage
- **Redis Server**: Provides caching and session storage
- **Private Network**: Secure communication between servers
- **Firewall Rules**: Proper security configuration
- **SSL Certificate**: Automatic Let's Encrypt certificate for `humhub.sprantic.ai`

## Prerequisites

1. **Hetzner Cloud Account**: Sign up at [console.hetzner.cloud](https://console.hetzner.cloud/)
2. **API Token**: Create an API token in your Hetzner Cloud project
3. **SSH Key Pair**: Generate an SSH key pair for server access
4. **Terraform**: Install Terraform >= 1.0
5. **Domain Configuration**: DNS A record for `humhub.sprantic.ai` pointing to the server IP

## Quick Start

1. **Clone and Navigate**:
   ```bash
   git clone <repository-url>
   cd terraform-hcloud-humhub/examples/basic
   ```

2. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your configuration
   ```

3. **Initialize and Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Configure DNS** (before applying):
   ```bash
   # Get the application server IP from terraform output
   terraform output app_server_ip
   
   # Create DNS A record:
   # humhub.sprantic.ai -> <app_server_ip>
   ```

5. **Access HumHub**:
   - Navigate to https://humhub.sprantic.ai
   - Use the admin credentials you configured
   - Complete the HumHub setup wizard

## Configuration

### Required Variables

- `hcloud_token`: Your Hetzner Cloud API token
- `ssh_public_key`: Your SSH public key for server access

### Important Variables

- `project_name`: Prefix for all resources (default: "humhub-example")
- `server_location`: Hetzner Cloud location (default: "nbg1")
- `domain_name`: Your domain for HumHub (optional)
- `enable_ssl`: Enable Let's Encrypt SSL (requires domain)
- `allowed_ssh_ips`: IP addresses allowed SSH access

### Server Sizing

Default server types:
- Application: cx21 (2 vCPUs, 4 GB RAM)
- Database: cx21 (2 vCPUs, 4 GB RAM)  
- Redis: cx11 (1 vCPU, 4 GB RAM)

For production workloads, consider larger server types.

## Security Considerations

1. **SSH Access**: Restrict `allowed_ssh_ips` to your IP address
2. **Firewall**: Only necessary ports are exposed
3. **Private Network**: Database and Redis are only accessible internally
4. **SSL/TLS**: Enable SSL for production deployments
5. **Passwords**: Use strong passwords for admin accounts

## Post-Deployment

1. **SSH Access**:
   ```bash
   ssh root@<app-server-ip>
   ssh root@<database-server-ip>
   ssh root@<redis-server-ip>
   ```

2. **HumHub Setup**:
   - Navigate to the HumHub URL
   - Complete the installation wizard
   - Configure your community settings

3. **Backups**: Automated backups are enabled by default
   - Database backups: `/opt/humhub-backups/` on database server
   - Application backups: `/opt/humhub-backups/` on app server

## Monitoring

If monitoring is enabled (`monitoring_enabled = true`):
- Prometheus: `http://<app-server-ip>:9090`
- Grafana: `http://<app-server-ip>:3000`
- Node Exporter: Port 9100 on all servers

## Keycloak Integration

To enable Keycloak SSO:
1. Set `keycloak_integration = true`
2. Configure Keycloak server details
3. Install the HumHub Keycloak module after deployment

## Troubleshooting

### Common Issues

1. **Cloud-init not completing**: Check `/var/log/cloud-init-output.log`
2. **Ansible failures**: Check `/opt/ansible-setup.sh` logs
3. **Service issues**: Use `systemctl status <service>`

### Useful Commands

```bash
# Check cloud-init status
cloud-init status

# View cloud-init logs
tail -f /var/log/cloud-init-output.log

# Check service status
systemctl status nginx php8.1-fpm mysql redis

# View HumHub logs
tail -f /var/www/humhub/protected/runtime/logs/app.log
```

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Cost Estimation

Monthly costs (approximate):
- cx11 server: €4.15/month
- cx21 server: €8.21/month
- Network: Free
- Load Balancer (if enabled): €5.39/month

Total for basic setup: ~€20.57/month

## Support

For issues with:
- **Terraform Module**: Check the main repository issues
- **HumHub**: Visit [HumHub Documentation](https://docs.humhub.org/)
- **Hetzner Cloud**: Check [Hetzner Cloud Docs](https://docs.hetzner.cloud/)