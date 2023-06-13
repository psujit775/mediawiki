#!/bin/bash

# Check if /config/LocalSettings.php exists
if [ -f /config/LocalSettings.php ]; then
  echo "Copying LocalSettings.php..."
  cp /config/LocalSettings.php /var/www/html/LocalSettings.php
else
  echo "LocalSettings.php not found. Starting without it..."
fi

# Start Apache in the foreground
apache2-foreground
