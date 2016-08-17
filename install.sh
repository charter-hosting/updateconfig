#!/bin/bash

cd /web

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

echo "Giving update script execute permission"
chmod +x wpupdate.sh

echo "Setting .htaccess rule to block direct access to update log and script file"
echo

touch .htaccess

echo "# START Deny access to wpupdate files" >> .htaccess
echo "<FilesMatch \"wpupdate\.log|wpupdate\.sh\">" >> .htaccess
echo "Order Allow,Deny" >> .htaccess
echo "Allow from 127.0.0.1" >> .htaccess
echo "Deny from all" >> .htaccess
echo "</FilesMatch>" >> .htaccess
echo "# END Deny access to wpupdate files" >> .htaccess
echo
echo "***********************"
echo "CONFIGURATION COMPLETE!"
echo "***********************"
echo
echo "Don't forget to:"
echo "- 1. Update the wp-config.php file with the code below"
echo
echo "/** Tell WP-CLI to use TCP instead of socket connection */"
echo "if ( defined( 'WP_CLI' ) && WP_CLI ) {"
echo "/** MySQL hostname for WP-CLI */"
echo "define('DB_HOST', '127.0.0.1:3306');"
echo "} else {"
echo "/** MySQL hostname */"
echo "define('DB_HOST', 'localhost'); }"
echo
echo "- 2. Set a cron to run 33 */12 * * * /web/wpupdate.sh >> /web/wpupdate.log"
echo

exit 0
