#!/bin/bash

cd /web

echo Creating log file wpupdate.log
touch wpupdate.log

echo Writing update script to file
cat <<EOF >wpupdate.sh
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

echo Setting .htaccess rule to block direct access to update log and script file
cat <<EOF >.htaccess
<FilesMatch "wpupdate\.log|wpupdate\.sh">
    Order Allow,Deny
    Allow from 127.0.0.1
    Deny from all
</FilesMatch>
EOF

echo Creating sample data wp-config-data.txt file
cat <<EOF >wp-config-data.txt
/** Tell WP-CLI to use TCP instead of socket connection */
if ( defined( 'WP_CLI' ) && WP_CLI ) {
/** MySQL hostname for WP-CLI */
define('DB_HOST', '127.0.0.1:3306');
} else {
/** MySQL hostname */
('DB_HOST', 'localhost'); }
EOF

chmod 0644 wp-config-data.txt

echo Configuration Complete!
echo Don't forget to update the wp-config.php file to use TCP.
echo Sample data in the wp-config-data.txt
exit 0
