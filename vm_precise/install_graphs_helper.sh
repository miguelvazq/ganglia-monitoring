#!/bin/bash

# Prerequistes
# apt-get install ganglia-webfrontend gmetad ganglia-monitor python-lxml collectd-core libltdl7 libganglia1 libapr1 libconfuse0 libxslt1.1 libconfuse-common -y
# dpkg -i hpccsystems-ganglia-monitoring--precise_*.deb

# Aliasing Apache web directory to use ganglia-webfrontend
echo "Updating apache2.conf..."; \
echo "Alias /ganglia /usr/share/ganglia-webfrontend" >> /etc/apache2/apache2.conf; \
\
# Customizing demo VM names and labels
echo "Updatating gmetad.conf..."; \
sed 's/my cluster\" localhost/VM Cluster\" localhost/g' < /etc/ganglia/gmetad.conf > /tmp/gmetad.conf; mv /tmp/gmetad.conf /etc/ganglia/gmetad.conf; \
echo "gridname \"VM\"" >> /etc/ganglia/gmetad.conf; \
\
# Setting up VM settings to get graphs up and running.  This overwrites many of the installed files.
echo "copying header.tpl to /usr/share/ganglia-webfrontend/templates/default"; \
cp -f ./header.tpl  /usr/share/ganglia-webfrontend/templates/default; \
echo "copying host_view.tpl to /usr/share/ganglia-webfrontend/templates/default"; \
cp -f ./host_view.tpl  /usr/share/ganglia-webfrontend/templates/default; \
echo "copying cluster_view.tpl to /usr/share/ganglia-webfrontend/templates/default"; \
cp -f ./cluster_view.tpl  /usr/share/ganglia-webfrontend/templates/default; \
\
echo "copying conf.php to /usr/share/ganglia-webfrontend"; \
cp -f ./conf.php /usr/share/ganglia-webfrontend/; \
echo "copying get_context.php to /usr/share/ganglia-webfrontend"; \
cp -f ./get_context.php /usr/share/ganglia-webfrontend/; \
echo "copying cluster_view.php to /usr/share/ganglia-webfrontend"; \
cp -f ./cluster_view.php /usr/share/ganglia-webfrontend/; \
\
echo "copying query_count_report.php to /usr/share/ganglia-webfrontend/graph.d"; \
cp -f ./query_count_report.php /usr/share/ganglia-webfrontend/graph.d; \
echo "copying query_count_s_report.php to /usr/share/ganglia-webfrontend/graph.d"; \
cp -f ./query_count_s_report.php /usr/share/ganglia-webfrontend/graph.d; \
echo "copying roxie_instances.php to /usr/share/ganglia-webfrontend/graph.d"; \
cp -f ./roxie_instances_report.php /usr/share/ganglia-webfrontend/graph.d; \
\
echo "mkdir /etc/ganglia/conf.d"; \
mkdir /etc/ganglia/conf.d; \
echo "copying modpython.conf to /etc/ganglia/conf.d/"; \
cp -f ./modpython.conf /etc/ganglia/conf.d; \
echo "copying gmond.conf to /etc/ganglia/"; \
cp -f ./gmond.conf /etc/ganglia; \
\
echo "copying hpcc_logo.png to /usr/share/ganglia-webfrontend/templates/default/images"; \
cp -f ./hpcc_logo.png /usr/share/ganglia-webfrontend/templates/default/images/; \
\
\
# Set gmond to start on reboot
echo "cp -sf /usr/sbin/gmond /etc/init.d/"; \
cp -sf /usr/sbin/gmond /etc/init.d/; \
\
echo "Cleaning and restarting services"; \
service gmetad stop; \
killall gmond; \
gmond; \
apachectl -k stop; \
sleep 5; \
\
rm -rf /var/lib/ganglia/rrds/*; \
\
service gmetad restart; \
gmond; \
apachectl -k restart; \
echo "Done."
