#!/bin/bash


sudo apt-get update -y
sudo apt-get install unzip git sox gnupg2 curl libnewt-dev libssl-dev libncurses5-dev subversion libsqlite3-dev build-essential libjansson-dev libxml2-dev libedit-dev uuid-dev subversion -y
# URL for the Asterisk download
ASTERISK_URL="https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz"

# Directory to download and extract the file
DOWNLOAD_DIR="$HOME/asterisk_download"

# Create the directory if it doesn't exist
mkdir -p $DOWNLOAD_DIR

# Change to the download directory
cd $DOWNLOAD_DIR

# Download the file
echo "Downloading Asterisk..."
wget $ASTERISK_URL

# Extract the file
echo "Extracting the Asterisk package..."
tar -xzf asterisk-20-current.tar.gz

# Successful extraction message
echo "Asterisk has been successfully downloaded and extracted."

# Optional: Change to the extracted directory
# You can customize this if you want to run additional commands.
cd asterisk-20.*

sudo contrib/scripts/get_mp3_source.sh
sudo contrib/scripts/install_prereq install

sudo ./configure

sudo make -j2
sudo make install

sudo make samples
sudo make config
sudo ldconfig

sudo groupadd asterisk
sudo useradd -r -d /var/lib/asterisk -g asterisk asterisk
sudo usermod -aG audio,dialout asterisk

sudo chown -R asterisk:asterisk /etc/asterisk
sudo chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk
sudo chown -R asterisk:asterisk /usr/lib/asterisk

sudo nano /etc/default/asterisk

sudo AST_USER="asterisk"
sudo AST_GROUP="asterisk"

# Path to Asterisk configuration file
ASTERISK_CONF="/etc/asterisk/asterisk.conf"

# Append the necessary user and group settings to the config file
echo "Appending user and group settings to $ASTERISK_CONF..."

sudo bash -c "echo 'runuser = asterisk ; The user to run as.' >> $ASTERISK_CONF"
sudo bash -c "echo 'rungroup = asterisk ; The group to run as.' >> $ASTERISK_CONF"

echo "Settings successfully appended to $ASTERISK_CONF"

sudo systemctl restart asterisk
sudo systemctl enable asterisk
#sudo systemctl status asterisk

sudo sed -i 's";\[radius\]"\[radius\]"g' /etc/asterisk/cdr.conf
sudo sed -i 's";radiuscfg => /usr/local/etc/radiusclient-ng/radiusclient.conf"radiuscfg => 
/etc/radcli/radiusclient.conf"g' /etc/asterisk/cdr.conf

sudo sed -i 's";radiuscfg => /usr/local/etc/radiusclient-ng/radiusclient.conf"radiuscfg => 
/etc/radcli/radiusclient.conf"g' /etc/asterisk/cel.conf

sudo systemctl start asterisk

sudo apt install software-properties-common

sudo add-apt-repository ppa:ondrej/php -y

sudo apt install -y apache2 mariadb-server libapache2-mod-php7.4 php7.4 php-pear php7.4-cgi php7.4-common php7.4-curl php7.4-mbstring php7.4-gd php7.4-mysql php7.4-bcmath php7.4-zip php7.4-xml php7.4-imap php7.4-json php7.4-snmp

wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-16.0-latest.tgz

tar -xvzf freepbx-16.0-latest.tgz

cd freepbx

sudo apt-get install nodejs npm -y

sudo ./install -n

sudo fwconsole ma install pm2

sudo sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf

sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

sudo sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/apache2/php.ini

sudo sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/cli/php.ini

sudo a2enmod rewrite

sudo systemctl restart apache2

# IP-Adresse herausfinden und in die Variable speichern
ip_address=$(hostname -I | awk '{print $1}')

# Falls hostname -I nicht funktioniert, kannst du alternative Methoden verwenden:
# ip_address=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Überprüfen, ob die IP-Adresse erfolgreich gesetzt wurde
if [ -z "$ip_address" ]; then
    echo "Fehler: IP-Adresse konnte nicht ermittelt werden."
    exit 1
fi

# Ausgabe der Links mit der richtigen IP-Adresse
echo "###################################################################"
echo "Open Browser and enter http://$ip_address/admin"
echo "###################################################################"











































