
package 'postgresql-server' do
    action :install
end

base_dir = '/var/lib/pgsql/data'

directory "#{base_dir}" do
    owner 'postgres'
    group 'postgres'
    action :create
end

execute "postgresql-setup initdb" do
    user "postgres"
    not_if { ::File.exist?("#{base_dir}/PG_VERSION")}
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
end
