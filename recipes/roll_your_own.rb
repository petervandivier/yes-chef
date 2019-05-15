
package 'postgresql-server' do
    action :install
end

base_dir = '/var/lib/pgsql/data'
bkp_dir = '/var/lib/pgsql/backup'

directory "#{base_dir}" do
    owner 'postgres'
    group 'postgres'
    action :create
end

directory "#{bkp_dir}" do
    owner 'postgres'
    group 'postgres'
    action :create
end

execute "postgresql-setup initdb" do
    user "postgres"
    not_if { ::File.exist?("#{base_dir}/PG_VERSION")}
end

execute "#{base_dir}/pg_ctl stop" do
    user "postgres"
    not_if {`systemctl status postgresql.service`}
end

cookbook_file "#{base_dir}/postgresql.conf" do
    source 'postgresql.conf'
    owner 'postgres'
    group 'postgres'
    mode 0600
    notifies :reload, 'service[postgresql]'
end

cookbook_file "#{base_dir}/pg_hba.conf" do
    source 'pg_hba.conf'
    owner 'postgres'
    group 'postgres'
    mode 0600
    notifies :reload, 'service[postgresql]'
end

service 'postgresql' do
    action [:enable,:start]
#    only_if {`sudo -u postgres #{base_dir}/pg_ctl status | grep 'server is running' | wc -l` == 0}
end
