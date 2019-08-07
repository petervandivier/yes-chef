
base_bkp  = node['pg']['hadr']['base_bkp']
wal_arch  = node['pg']['hadr']['wal_archive']
tar_dir   = node['pg']['hadr']['tar_dir'] 
pg_etc    = node['pg']['etc']
basebkp_sh = "#{pg_etc}/basebackup.sh"
arch_cmd_sh  = "#{pg_etc}/archive_command.sh"

# TODO: figure out a sensible way to do this
# ...probably not this one-liner, though...
# https://stackoverflow.com/a/35956324/4709762
directory "/data/bkp" do
    owner 'postgres'
    group 'postgres'
    mode 0o700
end

[base_bkp, wal_arch, tar_dir].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o700
    end
end

node.default['pg']['conf']['file']['lines'] << {key: 'archive_command', value: "#{arch_cmd_sh} %f %p"}
node.default['pg']['conf']['file']['lines'] << {key: 'archive_mode',    value: 'always'}
node.default['pg']['conf']['file']['lines'] << {key: 'archive_timeout', value: '5min'}

template arch_cmd_sh do
    owner 'postgres'
    group 'postgres'
    mode 0o700
    source 'backup/archive_command.sh.erb'
end

template basebkp_sh do
    owner 'postgres'
    group 'postgres'
    mode 0o700
    source 'backup/basebackup.sh.erb'
end

template "#{pg_etc}/switch_wal.sh" do
    owner 'postgres'
    group 'postgres'
    mode 0o700
    source 'backup/switch_wal.sh.erb'
end

cron 'pg_basebackup' do
    minute 0
    hour 0
    day '*'
    user 'postgres'
    command basebkp_sh
end

execute 'init_basebackup' do
    cwd "/data"
    user 'postgres'
    command basebkp_sh
    live_stream true
    not_if { ::File.exist?("#{node['pg']['base']}/PG_VERSION") }
end
