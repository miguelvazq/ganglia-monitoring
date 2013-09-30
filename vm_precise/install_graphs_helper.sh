#!/bin/bash

apt-get install ganglia-webfrontend gmetad ganglia-monitor python-lxml -y

echo "Alias /ganglia /usr/share/ganglia-webfrontend" >> /etc/apache2/apache2.conf
sed 's/my cluster\" localhost/VM Cluster\" localhost/g' < /etc/ganglia/gmetad.conf > /tmp/gmetad.conf; mv /tmp/gmetad.conf /etc/ganglia/gmetad.conf
echo "grid name \"VM Grid\"" >> /etc/ganglia/gmetad.conf

dpkg -i hpccsystems-ganglia-monitoring--precise_amd64.deb

cp -f ./conf.php /usr/share/ganglia-webfrontend/
cp -f ./header.tpl  /usr/share/ganglia-webfrontend/
cp -f ./host_view.tpl  /usr/share/ganglia-webfrontend/
cp -f ./cluster_view.tpl  /usr/share/ganglia-webfrontend/
cp -f ./get_context.php /usr/share/ganglia-webfrontend/
cp -f ./cluster_view.php /usr/share/ganglia-webfrontend/
cp -f ./hpcc-logo.png /usr/share/ganglia-webfrontend/templates/default/image/
cp -f ./query_count.php /usr/sahre/ganglia-webfrontend/graph.d
cp -f ./modpython.conf /etc/ganglia.conf.d

restart service gmetad
killall gmond
cp -s /usr/sbin/gmond /etc/init.d/
gmond

