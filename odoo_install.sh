DOMAIN_NAME="domainname.com"
NGINX_CONF="/etc/nginx/sites-available/odoo.conf"
SSL_EMAIL="hello@odoocrafts.com"

cd /opt
mkdir odoo && cd odoo
adduser --system --home=/opt/odoo --group odoo
sudo chown -R odoo:odoo /opt/odoo
sudo apt update
sudo apt upgrade -y
sudo -u odoo git clone https://github.com/odoo/odoo -b 18.0 --depth 1
mv odoo odoo-18.0
cd odoo-18.0/
sudo -u odoo mkdir Custom_Addons

sudo ./setup/debinstall.sh
sudo apt install python3.12-venv -y
sudo apt install python3-dev -y
sudo apt install libpq-dev gcc -y
sudo apt install build-essential wget git python3-pip python3-dev python3-venv python3-wheel python3 libfreetype6-dev libxml2-dev libzip-dev libsasl2-dev python3-setuptools libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libopenjp2-7-dev -y
sudo apt install npm -y
sudo npm install -g rtlcss

#Python requirements
python3 -m venv venv
sudo -u odoo wget https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/requirements_py312_fixed.txt
source venv/bin/activate
pip install -r requirements_py312_fixed.txt

#Postgres
sudo apt install postgresql postgresql-client -y
sudo -u postgres createuser --createdb --username postgres --no-createrole --no-superuser --no-password odoo
sudo -u odoo createdb odoo
# Set PostgreSQL tuning parameters via ALTER SYSTEM
sudo -u postgres psql <<EOF
ALTER SYSTEM SET max_connections = '200';
ALTER SYSTEM SET shared_buffers = '512MB';
ALTER SYSTEM SET effective_cache_size = '1536MB';
ALTER SYSTEM SET maintenance_work_mem = '128MB';
ALTER SYSTEM SET checkpoint_completion_target = '0.9';
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = '100';
ALTER SYSTEM SET random_page_cost = '1.1';
ALTER SYSTEM SET effective_io_concurrency = '200';
ALTER SYSTEM SET work_mem = '2520kB';
ALTER SYSTEM SET huge_pages = 'off';
ALTER SYSTEM SET min_wal_size = '1GB';
ALTER SYSTEM SET max_wal_size = '4GB';
EOF

# Reload or restart PostgreSQL to apply changes
systemctl restart postgresql

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt-get install -f -y
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb

#add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
# Set swappiness to reduce swapping
echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
# Apply the new setting immediately without reboot
sysctl -p

#ngix
sudo apt install nginx -y
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/nginx_http.conf -o "$NGINX_CONF"
sudo sed -i "s/domainname\.com/$DOMAIN_NAME/g" "$NGINX_CONF"
sudo ln -s /etc/nginx/sites-available/odoo.conf /etc/nginx/sites-enabled/odoo.conf
sudo nginx -t
sudo service nginx restart
#ssl
sudo apt install python3-certbot-nginx -y
sudo certbot --nginx --non-interactive --agree-tos --email "$SSL_EMAIL" -d "$DOMAIN_NAME"
sudo rm -f "$NGINX_CONF"
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/18.0/nginx_ssl.conf -o "$NGINX_CONF"
sudo sed -i "s/domainname\.com/$DOMAIN_NAME/g" "$NGINX_CONF"
sudo nginx -t
sudo service nginx restart


#Set Odoo
mkdir /etc/odoo
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/odoo.conf -o "/etc/odoo/odoo.conf"
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/odoo18.service -o "/lib/systemd/system/odoo18.service"
sudo systemctl daemon-reload
sudo systemctl start odoo18
#Wait for the test database to initialize to avoid any db init errors
sleep 20
# Define the path to the service file
SERVICE_FILE="/etc/systemd/system/odoo.service"
# Remove `-d ... -i ...` from ExecStart line
sudo sed -i 's/ -d[[:space:]]\+[^[:space:]]\+[[:space:]]\+-i[[:space:]]\+[^[:space:]]\+//' "$SERVICE_FILE"
sudo systemctl daemon-reload
sudo systemctl restart odoo18
sudo systemctl enable odoo18
