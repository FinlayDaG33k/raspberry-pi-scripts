#!/bin/sh
apt-get update && apt-get install apache2 php5-common php5-mysql libapache2-mod-php5 && service apache2 restart
