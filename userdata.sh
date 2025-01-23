#!/bin/bash
# Update the system packages
sudo yum update -y

# Install NGINX
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Start NGINX service
sudo systemctl start nginx
sudo systemctl enable nginx

# Optionally, allow HTTP traffic through the firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
