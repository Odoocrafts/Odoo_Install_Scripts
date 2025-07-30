DOMAIN_NAME="testserver.datasoupit.com"
NGINX_CONF="/etc/nginx/sites-available/odoo.conf"
SSL_EMAIL="hello@odoocrafts.com"

cd /opt
mkdir odoo && cd odoo
adduser --system --home=/opt/odoo --group odoo
sudo chown -R odoo:odoo /opt/odoo
sudo apt update
sudo apt upgrade
sudo -u odoo git clone https://github.com/odoo/odoo -b 18.0 --depth 1
mv odoo odoo-18.0
cd odoo-18.0/
sudo -u odoo mkdir Custom_Addons

sudo ./setup/debinstall.sh
sudo apt install python3.12-venv
sudo apt install python3-dev
sudo apt install libpq-dev gcc
sudo apt install build-essential wget git python3-pip python3-dev python3-venv python3-wheel python3 libfreetype6-dev libxml2-dev libzip-dev libsasl2-dev python3-setuptools libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libopenjp2-7-dev -y
sudo apt install npm
sudo npm install -g rtlcss

#Python requirements
python3 -m venv venv
sudo -u odoo wget https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/requirements_py312_fixed.txt
source venv/bin/activate
pip install -r requirements_py312_fixed.txt

sudo apt install postgresql postgresql-client
sudo -u postgres createuser --createdb --username postgres --no-createrole --no-superuser --no-password odoo
sudo -u odoo createdb odoo

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt-get install -f
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
sudo apt install nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/refs/heads/18.0/nginx_http.conf -o "$NGINX_CONF"
sudo sed -i "s/domainname\.com/$DOMAIN_NAME/g" "$NGINX_CONF"
sudo ln -s /etc/nginx/sites-available/odoo.conf /etc/nginx/sites-enabled/odoo.conf
sudo nginx -t
sudo service nginx restart
#ssl
sudo apt install python3-certbot-nginx
sudo certbot --nginx --non-interactive --agree-tos --email "$SSL_EMAIL" -d "$DOMAIN_NAME"
sudo rm -f "$NGINX_CONF"
curl -sSL https://raw.githubusercontent.com/Odoocrafts/Odoo_Install_Scripts/18.0/nginx_ssl.conf -o "$NGINX_CONF"
sudo sed -i "s/domainname\.com/$DOMAIN_NAME/g" "$NGINX_CONF"
sudo nginx -t
sudo service nginx restart
