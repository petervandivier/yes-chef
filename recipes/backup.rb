
base_bkp  = node['pg']['hadr']['base_bkp']
wal_arch  = node['pg']['hadr']['wal_archive']
basebkp_sh = "#{node['pg']['etc']}/basebackup.sh"
arch_cmd_sh  = "#{node['pg']['etc']}/archive_command.sh"

[base_bkp, wal_arch].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o705
        recursive true
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

template arch_cmd_sh do
    owner 'postgres'
    group 'postgres'
    mode 0o700
    source 'backup/archive_command.sh.erb'
end

template basebkp_sh do
    owner 'postgres'
    group 'postgres'
    mode 0o701
    source 'backup/basebackup.sh.erb'
end

cron 'pg_basebackup' do
    minute 0
    hour 0
    day '*'
    user 'postgres'
    command basebkp_sh
end

# TODO: execute only_if no base exists?
execute 'init_basebackup' do
    user 'postgres'
    command basebkp_sh
    live_stream true
end
