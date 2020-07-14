#!/usr/bin/env bash

# https://computingforgeeks.com/how-to-install-elasticsearch-on-centos/

# yum -y update

yes | yum -y install java-1.8.0-openjdk  java-1.8.0-openjdk-devel

cat <<EOF | sudo tee /etc/profile.d/java8.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF

source /etc/profile.d/java8.sh

cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/oss-7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum clean all

yum makecache

yum -y install elasticsearch-oss

# rpm -qi elasticsearch-oss
# vi /etc/elasticsearch/jvm.options

systemctl enable --now elasticsearch

# curl -X PUT "http://127.0.0.1:9200/test_index"

yes | yum install kibana-oss logstash


kibana_yml='/etc/kibana/kibana.yml'

echo 'server.host: "0.0.0.0"' >> $kibana_yml
echo 'server.name: "kibana.example.com"' >> $kibana_yml
echo 'elasticsearch.url: "http://localhost:9200"' >> $kibana_yml

systemctl enable --now kibana



# TODO: firewalld      
# firewall-cmd --add-port=5601/tcp --permanent
# firewall-cmd --reload
