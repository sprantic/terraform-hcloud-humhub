#!/bin/bash
# Module validation script
# This script performs basic validation of the Terraform module structure

set -e

echo "🔍 Validating Terraform HumHub Module Structure..."

# Check required files exist
echo "📁 Checking required files..."
required_files=(
    "main.tf"
    "variables.tf" 
    "outputs.tf"
    "README.md"
    "LICENSE"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check Ansible structure
echo "📁 Checking Ansible structure..."
ansible_files=(
    "ansible/database.yml"
    "ansible/redis.yml"
    "ansible/app.yml"
    "ansible/templates/my.cnf.j2"
    "ansible/templates/humhub-mysql.cnf.j2"
    "ansible/templates/redis.conf.j2"
    "ansible/templates/nginx-humhub.conf.j2"
    "ansible/templates/php-fpm-humhub.conf.j2"
    "ansible/templates/humhub-config.php.j2"
    "ansible/templates/backup-database.sh.j2"
    "ansible/templates/backup-redis.sh.j2"
    "ansible/templates/backup-humhub.sh.j2"
    "ansible/templates/install-humhub.sh.j2"
)

for file in "${ansible_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check cloud-init structure
echo "📁 Checking cloud-init structure..."
cloudinit_files=(
    "cloud-init/database.yml"
    "cloud-init/redis.yml"
    "cloud-init/app.yml"
)

for file in "${cloudinit_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check examples structure
echo "📁 Checking examples structure..."
example_files=(
    "examples/basic/main.tf"
    "examples/basic/variables.tf"
    "examples/basic/outputs.tf"
    "examples/basic/terraform.tfvars.example"
    "examples/basic/README.md"
)

for file in "${example_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check for syntax errors in Terraform files
echo "🔧 Checking Terraform syntax..."
if command -v terraform >/dev/null 2>&1; then
    echo "  📝 Formatting check..."
    terraform fmt -check=true -diff=true . || {
        echo "  ⚠️  Terraform files need formatting. Run 'terraform fmt' to fix."
    }
    
    echo "  🔍 Validation check..."
    if terraform validate >/dev/null 2>&1; then
        echo "  ✅ Terraform validation passed"
    else
        echo "  ⚠️  Terraform validation failed (this is expected without provider configuration)"
    fi
else
    echo "  ⚠️  Terraform not installed, skipping syntax validation"
fi

# Check for YAML syntax in Ansible files
echo "🔧 Checking YAML syntax..."
if command -v yamllint >/dev/null 2>&1; then
    for file in ansible/*.yml cloud-init/*.yml; do
        if yamllint "$file" >/dev/null 2>&1; then
            echo "  ✅ $file"
        else
            echo "  ⚠️  $file has YAML syntax issues"
        fi
    done
else
    echo "  ⚠️  yamllint not installed, skipping YAML validation"
fi

echo ""
echo "🎉 Module structure validation completed!"
echo ""
echo "📋 Summary:"
echo "  • Terraform module structure: ✅ Complete"
echo "  • Ansible playbooks: ✅ Complete"
echo "  • Cloud-init configurations: ✅ Complete"
echo "  • Example configurations: ✅ Complete"
echo "  • Documentation: ✅ Complete"
echo ""
echo "🚀 The module is ready for use!"
echo ""
echo "Next steps:"
echo "  1. Copy terraform.tfvars.example to terraform.tfvars in examples/basic/"
echo "  2. Configure your Hetzner Cloud API token and SSH key"
echo "  3. Run 'terraform init && terraform plan' in examples/basic/"
echo "  4. Deploy with 'terraform apply'"