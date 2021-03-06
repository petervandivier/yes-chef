
# sudo echo "export PATH=\$PATH:#{bin}" >> /etc/profile
# sudo echo "export PGDATA=#{base}" >> /etc/profile
# source /etc/profile

base      = node['pg']['base']
log       = node['pg']['log'] 
etc       = node['pg']['etc'] 
bin       = node['pg']['bin'] 
conf_dir  = node['pg']['conf']['dir']
conf_file = node['pg']['conf']['file']['path']
hba_file  = node['pg']['conf']['hba']['path']

get_pg = <<EOF
yes | rpm -Uvh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# https://repmgr.org/docs/4.0/installation-packages.html
# yum install -y https://rpm.2ndquadrant.com/site/content/2ndquadrant-repo-10-1-1.el7.noarch.rpm
yum install -y postgresql10-server postgresql10 postgresql10-contrib repmgr10
EOF

# https://www.postgresql.org/docs/current/runtime-config-file-locations.html
# per docs, to keep conf files in separate directory from data_dir, you must
# initdb -D '/conf/dir' and specify data_directory in postgresql.conf
init_db = <<EOF
sudo -H -u postgres #{bin}/initdb -D #{base}
EOF

start_db = <<EOF
sudo -H -u postgres #{bin}/pg_ctl -D #{base} -l #{log}/log -o "--config-file=#{conf_file}" start
EOF

execute 'Load RPM' do
    command get_pg
end

directory "/data" do
    owner 'postgres'
    group 'postgres'
    mode 0o710
end

[log, conf_dir, etc].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o710
    end
end

template conf_file do
    source 'postgresql.conf.erb'
    owner 'postgres'
    group 'postgres'
    mode 0o605
end

template hba_file do
    source 'pg_hba.conf.erb'
    owner 'postgres'
    group 'postgres'
    mode 0o605
end

file "#{conf_dir}/pg_ident.conf" do
    owner 'postgres'
    group 'postgres'
    mode 0o605
    action :create
end

execute 'Init DB' do
    command init_db
    not_if {::File.exist?("#{base}/PG_VERSION")}
end

[
    "#{base}/postgresql.conf",
    "#{base}/pg_hba.conf",
    "#{base}/pg_ident.conf"
].each do |default_conf|
    file default_conf do
        action :delete
        backup false
    end
end

execute 'Start DB' do
    command start_db
    not_if {::File.exist?("#{base}/postmaster.pid")}
end
