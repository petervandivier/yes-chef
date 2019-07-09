
# https://tecadmin.net/install-postgresql-server-centos/

# sudo echo "export PATH=\$PATH:#{bin}" >> /etc/profile
# sudo echo "export PGDATA=#{base}" >> /etc/profile
# source /etc/profile

data     = '/data'
base     = '/data/postgresql'
log      = '/data/log'
base_bkp = '/data/basebackup'
wal_arch = '/data/wal_archive'
bin      = '/usr/pgsql-10/bin'

get_pg = <<EOF
yes | rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install -y postgresql10-server postgresql10
EOF

init_db = <<EOF
sudo -u postgres #{bin}/initdb -D #{base}
sudo -u postgres #{bin}/pg_ctl -D #{base} -l #{log}/logfile start
EOF

execute 'screw you, it works. YOU CAN`T JUDGE ME' do
    command get_pg
end

[data, base, log, base_bkp, wal_arch].each do |path|
    directory path do
        owner 'postgres'
        group 'postgres'
        mode 0o705
    end
end

execute 'YOU`RE NOT MY DAD' do
    command init_db
    not_if {::File.exist?("#{base}/PG_VERSION")}
end
