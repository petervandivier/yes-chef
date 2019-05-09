

package 'postgresql-server' do
    action :install
end

directory '/var/lib/pgsql/data' do
    owner 'postgres'
    group 'postgres'
    action :create
end

execute "postgresql-setup initdb" do
    user "postgres"
    not_if { ::File.exist?("/var/lib/pgsql/data/PG_VERSION")}
end

service 'postgresql' do
    action [:enable,:start]
end
