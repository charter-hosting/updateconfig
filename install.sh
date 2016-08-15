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

echo Configuration complete!
echo Don't forget to update the wp-config.php file to use TCP.
echo
echo /** Tell WP-CLI to use TCP instead of socket connection */
echo if ( defined( 'WP_CLI' ) && WP_CLI ) {
echo /** MySQL hostname for WP-CLI */
echo define('DB_HOST', '127.0.0.1:3306');
echo } else {
echo /** MySQL hostname */
echo define('DB_HOST', 'localhost'); }

exit 0