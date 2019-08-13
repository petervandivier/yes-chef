
# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat
# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup?view=sql-server-2017#unattended

wget_yum_repo = <<EOF
yum -y install wget 
wget https://packages.microsoft.com/config/rhel/7/mssql-server-preview.repo -O /etc/yum.repos.d/mssql-server.repo
EOF

execute "register yum repo" do
    command wget_yum_repo
end

# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-2017#use-with-initial-setup
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

# https://computingforgeeks.com/how-to-install-microsoft-sql-2019-on-centos-7-fedora/
get_utils = <<EOF
curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
yes | yum -y install mssql-tools 
yes | yum -y install unixODBC-devel
echo 'export PATH=$PATH:/opt/mssql/bin:/opt/mssql-tools/bin' 
EOF

execute "get utils" do
    command get_utils
end

# TODO: pwsh config on Centos
# https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6#centos-7
# curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
# sudo yum install -y powershell
