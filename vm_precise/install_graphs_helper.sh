#!/bin/bash

# Aliasing Apache web directory to use ganglia-webfrontend
echo "Alias /ganglia /usr/share/ganglia-webfrontend" >> /etc/apache2/apache2.conf

# Customizing demo VM names and labels
sed 's/my cluster\" localhost/VM Cluster\" localhost/g' < /etc/ganglia/gmetad.conf > /tmp/gmetad.conf; mv /tmp/gmetad.conf /etc/ganglia/gmetad.conf
echo "gridname \"VM Grid\"" >> /etc/ganglia/gmetad.conf

# Setting up VM settings to get graphs up and running.  This overwrites many of the installed files.
cp -f ./conf.php /usr/share/ganglia-webfrontend/

cp -f ./header.tpl  /usr/share/ganglia-webfrontend/templates/default
cp -f ./host_view.tpl  /usr/share/ganglia-webfrontend/templates/default
cp -f ./cluster_view.tpl  /usr/share/ganglia-webfrontend/templates/default

cp -f ./get_context.php /usr/share/ganglia-webfrontend/
cp -f ./cluster_view.php /usr/share/ganglia-webfrontend/

cp -f ./query_count_report.php /usr/share/ganglia-webfrontend/graph.d
cp -f ./query_count_s_report.php /usr/share/ganglia-webfrontend/graph.d
cp -f ./roxie_instances_report.php /usr/share/ganglia-webfrontend/graph.d

cp -f ./modpython.conf /etc/ganglia/conf.d
cp -f ./gmond.conf /etc/ganglia

cp -f ./hpcc_logo.png /usr/share/ganglia-webfrontend/templates/default/images/


# Set gmond to start on reboot
cp -sf /usr/sbin/gmond /etc/init.d/

service gmetad stop
killall gmond
gmond
apachectl -k stop

rm -rf /var/lib/ganglia/rrds/*

service gmetad start
gmond
apachectl -k start
