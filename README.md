# dodjango
Simple script to set up the already-mostly-configured Django droplet
on DigitalOcean.  Just run the script, and drop your project directory into
/home/django/

### Guide
run "bash dodjango.sh *projectname* *databasetype* *databasename* *databaseuser* *password*"
*   *projectname*: name of the top-level directory of your project
*   *databasetype*: database you're using; current options are 'postgres' and 'mongodb'
*   *databasename*: name of the database on your droplet
*   *databaeuser*: name of the database user for the app
*   *password*: password for the database user


Reminder: Options need to match those in settings.py in your project
