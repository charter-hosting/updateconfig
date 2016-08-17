#!/bin/bash

# This script configures automatic updates for WordPress core,
# themes and plugins using WP-CLI. Run this script in the root
# directory of your WordPress website.
#
# To install:
# wget --no-check-certificate https://raw.githubusercontent.com/charter-hosting/updateconfig/master/install.sh
# chmod +x
# ./install.sh
# rm install.sh

pwd=$(pwd)

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

touch $pwd/.htaccess
chmod 0644 $pwd/.htaccess

echo "# START Deny access to wpupdate files" >> .htaccess
echo "<FilesMatch \"wpupdate\.log|wpupdate\.sh\">" >> .htaccess
echo "Order Allow,Deny" >> .htaccess
echo "Allow from 127.0.0.1" >> .htaccess
echo "Deny from all" >> .htaccess
echo "</FilesMatch>" >> .htaccess
echo "# END Deny access to wpupdate files" >> .htaccess
echo
echo "*************************************************"
echo "********** * CONFIGURATION COMPLETE! * **********"
echo "*************************************************"
wp theme list
echo
echo "Do you see a database connection error above? If so, update the wp-config.php file"
echo "with the code below:"
echo
echo
echo "/** Tell WP-CLI to use TCP instead of socket connection */"
echo "if ( defined( 'WP_CLI' ) && WP_CLI ) {"
echo
echo "/** MySQL hostname for WP-CLI */"
echo "define('DB_HOST', '127.0.0.1:3306');"
echo
echo "} else {"
echo
echo "/** MySQL hostname */"
echo "define('DB_HOST', 'localhost'); }"
echo
echo
echo "Don't forget to set a cron to run 33 */12 * * * $pwd/wpupdate.sh >> $pwd/wpupdate.log"
echo

exit 0
