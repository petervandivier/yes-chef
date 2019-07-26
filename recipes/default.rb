
# sudo echo "export PATH=\$PATH:#{bin}" >> /etc/profile
# sudo echo "export PGDATA=#{base}" >> /etc/profile
# source /etc/profile

data      = '/data'
base      = node['pg']['base']
log       = node['pg']['log'] 
etc       = node['pg']['etc'] 
bin       = node['pg']['bin'] 
conf_dir  = node['pg']['conf']['path']
conf_file = node['pg']['conf']['file']['path']
hba_file  = node['pg']['conf']['hba']['path']

get_pg = <<EOF
yes | rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install -y postgresql10-server postgresql10
EOF

# https://www.postgresql.org/docs/current/runtime-config-file-locations.html
# per docs, to keep conf files in separate directory from data_dir, you must
# initdb -D '/conf/dir' and specify data_directory in postgresql.conf
init_db = <<EOF
sudo -u postgres #{bin}/initdb -D #{base}
EOF

start_db = <<EOF
sudo -u postgres #{bin}/pg_ctl -D #{base} -l #{log}/log -o "--config-file=#{conf_file}" start
EOF

execute 'Load RPM' do
    command get_pg
end

[data, base, log, conf_dir, etc].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o705
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

["#{base}/pg_hba.conf" "#{base}/pg_ident.conf" "#{base}/postgresql.conf"].each do |conf|
    file conf do
        action :delete
        not_if {::File.exist?("#{base}/postmaster.pid")}
    end
end

execute 'Start DB' do
    command start_db
    not_if {::File.exist?("#{base}/postmaster.pid")}
end
