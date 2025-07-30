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
sudo -u odoo createuser -d -R -S odoo
sudo -u odoo createdb odoo

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt-get install -f
sudo dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb
