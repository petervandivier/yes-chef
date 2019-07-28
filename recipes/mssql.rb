
wget_yum_repo = <<EOF
yum -y install wget 
wget https://packages.microsoft.com/config/rhel/7/mssql-server-preview.repo -O /etc/yum.repos.d/mssql-server.repo
EOF

execute "register yum repo" do
    command wget_yum_repo
end

unattended_install = <<EOF
pw=`openssl rand -base64 18`
yum install -y mssql-server
sudo MSSQL_PID=Developer ACCEPT_EULA=Y MSSQL_SA_PASSWORD=$pw /opt/mssql/bin/mssql-conf -n setup
echo $pw > /tmp/sapw
EOF

execute "install SQL Server" do
    command unattended_install
end

port_1433 = <<EOF
firewalld
firewall-cmd --permanent --add-port=1433/tcp
firewall-cmd --reload
EOF

execute "open ze port" do
    command port_1433
end
