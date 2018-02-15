#!/bin/bash

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server
chown -R shiny.shiny /srv/shiny-server/sample-apps/SIG/wallace/shiny
chmod +x /monitor_traffic.sh
exec /monitor_traffic.sh &


exec shiny-server 2>&1
