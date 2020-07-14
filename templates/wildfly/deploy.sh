#!/usr/bin/env bash
# 
# https://linuxize.com/post/how-to-install-wildfly-on-centos-7/

# Step 1: Install Java OpenJDK
yum -y install java-1.8.0-openjdk-devel

# Step 2: Create a User
groupadd -r wildfly
useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly

# Step 3: Install WildFly
WILDFLY_VERSION=16.0.0.Final
wget https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz -P /tmp

tar xf /tmp/wildfly-$WILDFLY_VERSION.tar.gz -C /opt/

ln -s /opt/wildfly-$WILDFLY_VERSION /opt/wildfly

chown -RH wildfly: /opt/wildfly

# Step 4: Configure Systemd
mkdir -p /etc/wildfly

cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/

cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

sh -c 'chmod +x /opt/wildfly/bin/*.sh'

cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/

systemctl daemon-reload

systemctl start wildfly
systemctl enable wildfly

# Step 5: Adjust the Firewall

systemctl start firewalld
firewall-cmd --zone=public --permanent --add-port=8080/tcp
firewall-cmd --reload

# Step 6: Configure WildFly Authentication

/opt/wildfly/bin/add-user.sh

# linuxize
# foobar1!
