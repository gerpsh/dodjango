#!/bin/bash
#$1: project name
#$2: database type
#$3: database name
#$4: database user for project
#$5: database user password
#$6: django version
sudo apt-get update
sudo pip install django==$6
if [ $2 == 'postgres' ]
  then
    sudo apt-get install libpq-dev postgresql postgresql-contrib
    sudo su - postgres
    DB="CREATE DATABASE $3;"
    USER="CREATE USER $4 WITH PASSWORD '$5';"
    ALTERPRIVS = "ALTER ROLE $4 SET client_encoding TO 'utf8'; ALTER ROLE $3 SET default_transaction_isolation TO 'read committed'; ALTER ROLE $3 SET timezone TO 'UTC';"
    GRANT="GRANT ALL PRIVILEGES ON DATABASE $3 TO $4;"
    psql -c $DB
    psql -c $USER
    psql -c $ALTERPRIVS
    psql -c $GRANT
    pip install django psycopg2
fi

if [ $2 == 'mongodb']
  then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    sudo apt-get update
    apt-get install mongodb-10gen=2.2.3
    sudo server mongodb start
    mongo --eval "use $3"
    mongo --eval "db.createUser( { user: '$4', pwd: '$5', roles: [ { role: 'readWrite', db: '$2' } ] } )"
    pip install mongoengine
fi

sed -i "s/django_project/$1/g" /etc/nginx/sites-enabled/django
sed -i "s/django_project/$1/g" /etc/init/gunicorn.conf

sudo rm -r /home/django/django_project
mkdir /home/django/$1
cd /home/django/$1

service gunicorn restart
