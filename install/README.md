INSTALLATION
============


INSTRUCTIONS
------------

- Login to phpMyAdmin.

- Create a database.

- Import the database structure from `database-schema.sql`.

- Modify the config located at `/system/config.php` with your database information.

- Access the following links: `http://hostname/system/database.php?action=sync&data=anidb`, `http://hostname/system/database.php?action=sync&data=title`, `http://hostname/system/database.php?action=sync&data=program`

- Setup a cron to run those commands/links to update information automatically.
