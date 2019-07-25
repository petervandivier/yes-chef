

base_bkp  = node['pg']['hadr']['base_bkp']
wal_arch  = node['pg']['hadr']['wal_archive']

[base_bkp, wal_arch].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o705
    end
end
