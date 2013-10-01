#!/bin/bash

# Installing Ganglia
apt-get install ganglia-webfrontend gmetad ganglia-monitor python-lxml collectd-core ganglia-monitor python-lxml libltdl7 libganglia1 libapr1 libconfuse0 libxslt1.1 libconfuse-common -y

# Aliasing Apache web directory to use ganglia-webfrontend
echo "Alias /ganglia /usr/share/ganglia-webfrontend" >> /etc/apache2/apache2.conf

# Customizing demo VM names and labels
sed 's/my cluster\" localhost/VM Cluster\" localhost/g' < /etc/ganglia/gmetad.conf > /tmp/gmetad.conf; mv /tmp/gmetad.conf /etc/ganglia/gmetad.conf
echo "gridname \"VM Grid\"" >> /etc/ganglia/gmetad.conf

# Installing HPCC specific settings for gmond data gathering.  This monitors the roxie service and gathers metrics for gmond.
dpkg -i hpccsystems-ganglia-monitoring--precise_*.deb

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

# Restarting ganglia metric aggregator
service gmetad restart

# Restarting gmond metric gathering process and setting it to start on reboots automatically
killall gmond
cp -sf /usr/sbin/gmond /etc/init.d/
gmond

# Restarting apache
apachectl -k restart
