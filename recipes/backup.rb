

base_bkp  = node['pg']['hadr']['base_bkp']
wal_arch  = node['pg']['hadr']['wal_archive']

[base_bkp, wal_arch].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o705
        recursive true
    end
end

node.default['pg']['conf']['hba']['records'] << {
    type: 'local', 
    db: 'replication', 
    user: 'postgres', 
    method: 'peer', 
    comment: 'required for basebackup'
}

node.default['pg']['conf']['file']['lines'] << {key: 'archive_command', value: "test ! -f #{wal_arch}/%f && cp %p #{wal_arch}/%f" }

template "#{node['pg']['etc']}/basebackup.sh" do
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
    command "#{node['pg']['etc']}/basebackup.sh"
end

