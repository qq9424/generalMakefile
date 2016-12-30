rm -fr /var/lock
rm -fr /var/run
rm -fr /var/log
mkdir /var/lock
mkdir /var/run
mkdir /var/log
mkdir /var/log/boa
touch /var/log/boa/access_log
touch /var/log/boa/error_log
chmod -R 777 /var/www/*
boa
