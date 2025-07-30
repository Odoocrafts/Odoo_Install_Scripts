cd /opt
mkdir odoo && cd odoo
sudo apt update
sudo apt upgrade
git clone https://github.com/odoo/odoo -b 18.0 --depth 1
cd odoo-18.0/
sudo ./setup/debinstall.sh
sudo apt install python3.12-venv
sudo apt install python3-dev
sudo apt install libpq-dev gcc
sudo apt install build-essential wget git python3-pip python3-dev python3-venv python3-wheel python3 libfreetype6-dev libxml2-dev libzip-dev libsasl2-dev python3-setuptools libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libopenjp2-7-dev -y
sudo apt install npm
sudo npm install -g rtlcss

python3 -m venv venv
