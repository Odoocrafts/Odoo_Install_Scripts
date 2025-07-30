# 🚀 Odoo 18 Community Edition - Production Install Script

This script automates the installation and setup of **Odoo 18 Community Edition** on an Ubuntu server for production use. It is designed for a VPS or cloud server with **at least 2GB RAM and 1 CPU**.

---

## ⚙️ Configuration Variables

| Variable      | Description                          |
|---------------|--------------------------------------|
| `DOMAIN_NAME` | Your domain name for the Odoo site   |
| `NGINX_CONF`  | Nginx config path                    |
| `SSL_EMAIL`   | Email used for SSL via Let's Encrypt |

---

## 📦 Features

- Creates `odoo` system user
- Clones Odoo 18 source from GitHub
- Sets up PostgreSQL 16
- Installs all dependencies:
  - Python 3.10, pip, venv
  - wkhtmltopdf (for PDF reports)
  - Node.js, npm, rtlcss
- Creates Python virtual environment for Odoo
- Installs required Python packages
- Creates Odoo config file with recommended settings
- Initializes `Custom_Addons` folder
- Configures PostgreSQL with performance tuning
- Adds and configures 2GB swap
- Installs and configures Nginx
- Adds free SSL using Certbot and replaces HTTP config
- Creates and enables `systemd` service to auto-start Odoo
- Fully ready-to-use production deployment

---

## 📂 Directory Structure
- /opt/odoo/odoo-18.0/ → Odoo source code
- /opt/odoo/odoo-18.0/Custom_Addons/ → Folder for custom addons
- /etc/odoo/odoo.conf → Odoo config file
- /etc/nginx/sites-available/odoo.conf → Nginx config file
- /lib/systemd/system/odoo18.service → Odoo service file

---

## 🔐 Security & Optimization

- Disables default Nginx site
- Installs and configures SSL via Certbot (Let's Encrypt)
- PostgreSQL optimized with:
  - `shared_buffers = 512MB`
  - `effective_cache_size = 1536MB`
  - `max_connections = 200`
  - `work_mem`, `maintenance_work_mem`, etc. adjusted for web workloads
- Adds 2GB swap for better memory management
- `vm.swappiness = 10` set for better RAM usage

---

## 🛠 Notes

- Certbot is used with the Nginx plugin to generate and apply SSL certs
- The systemd service originally includes `-d testdb1 -i base`, which is **removed** for production
- `sleep 20` ensures Odoo has time to initialize before altering the service
- You can safely deploy additional custom modules in the `Custom_Addons` folder

---

## ✅ Result

After the script runs successfully:

- Odoo 18 is available at `https://your-domain.com`
- SSL is fully configured
- PostgreSQL and system memory are tuned for performance
- Odoo runs as a system service (`odoo18`) and will start on boot

---

## 📞 Support

For issues, feel free to open a GitHub issue or contribute improvements to this repo.

---
