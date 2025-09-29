#!/bin/bash
# MySQL initialization script

# Create additional databases if needed
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "
CREATE DATABASE IF NOT EXISTS rehome_test;
GRANT ALL PRIVILEGES ON rehome_test.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
"

echo "Additional databases created successfully."