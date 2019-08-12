
require 'json'

pg_root = node['pg']['root']
pg_etc  = node['pg']['etc']

file '/tmp/dict.json' do
    content "#{node['pg'].to_json}"
end

group 'postgres' do
    append true
    members %w(vagrant)
    action :modify
end

%w[
    epel-release
    jq
    tree
].each do |pkg|
    package pkg do
        action :install
    end
end

# user 'postgres' do
#     manage_home true
#     home "#{node['pg']['root']}"
#     action :modify
# end

make_heartbeat_target=<<-EOF
psql -U postgres -c "create table if not exists heartbeat ( ts timestamp with time zone );" 
psql -U postgres -c "delete from heartbeat;" 
psql -U postgres -c "insert into heartbeat(ts) select now();"
EOF

execute 'make heartbeat target' do
    command make_heartbeat_target
end

cron 'heartbeat' do
    minute '*'
    command 'psql -U postgres -c "update heartbeat set ts = now() where not(pg_is_in_recovery());"'
end

link "#{pg_root}/sw" do
    to "#{pg_etc}/switch_wal.sh"
end

link "#{pg_root}/bbk" do
    to "#{pg_etc}/basebackup.sh"
end
