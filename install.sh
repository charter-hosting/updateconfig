#!/bin/bash

cd /web/test

echo "Creating log file wpupdate.log"
touch wpupdate.log

echo "Writing update script to file"
cat <<'EOF' >wpupdate.sh
#!/bin/bash
timestamp() {
  date "+DATE: %D TIME: %r %Z"
}

timestamp
wp theme update --all
wp plugin update --all
wp core language update
wp core update

exit 0
EOF

echo "Setting .htaccess rule to block direct access to update log and script file"
touch .htaccess
echo "<FilesMatch \"wpupdate\.log|wpupdate\.sh\">" >> .htaccess
echo "Order Allow,Deny" >> .htaccess
echo "Allow from 127.0.0.1" >> .htaccess
echo "Deny from all" >> .htaccess
echo "</FilesMatch>" >> .htaccess

echo "Configuration Complete!
echo "Don't forget to update the wp-config.php file to use TCP.
echo
echo "/** Tell WP-CLI to use TCP instead of socket connection */"
echo "if ( defined( 'WP_CLI' ) && WP_CLI ) {"
echo "/** MySQL hostname for WP-CLI */"
echo "define('DB_HOST', '127.0.0.1:3306');"
echo "} else {"
echo "/** MySQL hostname */"
echo "('DB_HOST', 'localhost'); }"

exit
