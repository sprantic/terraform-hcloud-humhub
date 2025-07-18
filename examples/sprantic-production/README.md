# HumHub for Sprantic.ai - Production Deployment

This example deploys a production-ready HumHub instance for Sprantic with SSL certificate and the domain `humhub.sprantic.ai`.

## Features

- **Domain**: `humhub.sprantic.ai` with automatic SSL certificate
- **Production Sizing**: Larger servers for better performance
- **Monitoring**: Prometheus and Grafana enabled
- **Security**: Hardened configuration with restricted access
- **Backups**: Automated daily backups
- **Performance**: Optimized PHP, MySQL, and Redis settings

## Prerequisites

1. **Hetzner Cloud Account** with API token
2. **SSH Key Pair** for server access
3. **DNS Access** to configure `humhub.sprantic.ai`

## DNS Configuration

**IMPORTANT**: Configure DNS before running Terraform to ensure SSL certificate generation works.

Create an A record in your DNS provider:
```
Type: A
Name: humhub.sprantic.ai
Value: <will be provided by terraform output>
TTL: 300
```

## Quick Deployment

1. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Get Server IP**:
   ```bash
   terraform output app_server_ip
   ```

4. **Update DNS**:
   - Point `humhub.sprantic.ai` to the app server IP
   - Wait for DNS propagation (usually 5-15 minutes)

5. **Access HumHub**:
   - Navigate to https://humhub.sprantic.ai
   - Complete the setup wizard
   - Login with admin credentials

## Server Configuration

- **Application Server**: cx31 (2 vCPUs, 8 GB RAM)
- **Database Server**: cx31 (2 vCPUs, 8 GB RAM)
- **Redis Server**: cx21 (2 vCPUs, 4 GB RAM)
- **Location**: Nuremberg, Germany (nbg1)

## Security Features

- SSH access restricted to specified IP ranges
- Private networking between servers
- Firewall rules for minimal exposure
- SSL/TLS encryption with Let's Encrypt
- Regular security updates

## Monitoring

Access monitoring dashboards:
- **Prometheus**: `http://<app_server_ip>:9090`
- **Grafana**: `http://<app_server_ip>:3000`

Default Grafana credentials will be displayed in the logs.

## Backup Information

Automated backups run daily:
- **Database**: 2:00 AM UTC
- **Application Files**: 3:00 AM UTC
- **Redis**: 2:30 AM UTC

Backups are stored locally on each server in `/opt/humhub-backups/`.

## Post-Deployment Tasks

1. **Complete HumHub Setup**:
   - Configure community settings
   - Set up user registration policies
   - Install additional modules if needed

2. **Security Hardening**:
   - Review and restrict `allowed_ssh_ips`
   - Set up monitoring alerts
   - Configure backup retention policies

3. **Performance Tuning**:
   - Monitor resource usage
   - Adjust server sizes if needed
   - Enable load balancer for high traffic

## Troubleshooting

### SSL Certificate Issues
```bash
# Check certificate status
ssh root@<app_server_ip>
certbot certificates

# Renew certificate manually if needed
certbot renew --nginx
```

### DNS Issues
```bash
# Check DNS resolution
nslookup humhub.sprantic.ai
dig humhub.sprantic.ai
```

### Service Status
```bash
# Check all services
systemctl status nginx php8.1-fpm mysql redis
```

## Cost Estimate

Monthly costs (approximate):
- 3x Servers (cx31 + cx31 + cx21): ~€41.14
- Network traffic: Usually free
- **Total**: ~€41.14/month

## Scaling Options

- **Load Balancer**: Set `enable_load_balancer = true`
- **Larger Servers**: Upgrade to cx41 or cx51 server types
- **Multiple App Servers**: Deploy additional application servers

## Support

For issues:
- Check `/var/log/cloud-init-output.log` for deployment issues
- Review HumHub logs at `/var/www/humhub/protected/runtime/logs/`
- Contact Sprantic team for domain-specific issues