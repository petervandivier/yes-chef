
default['pg']['conf']['path']           = '/usr/local/etc/postgresql/'
default['pg']['conf']['file']['path']   = '/usr/local/etc/postgresql/postgresql.conf'
default['pg']['conf']['file']['lines'] = [
# FILE LOCATIONS
    {key: 'data_directory', value: '/data/postgresql/'},
    {key: 'hba_file',       value: '/usr/local/etc/postgresql/pg_hba.conf'},
    {key: 'ident_file',     value: '/usr/local/etc/postgres/postgresql.conf'}
]
default['pg']['conf']['hba']['path']    = '/usr/local/etc/postgresql/pg_hba.conf'
default['pg']['conf']['hba']['records'] = [
    {type: 'local', db: 'all',         user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'postgres', method: 'peer',                           comment: 'required for basebackup'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '127.0.0.1/32', comment: 'IPv4 local connections:'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '::1/128',      comment: 'IPv6 local connections:'},
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '127.0.0.1/32'}, 
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '::1/128'}
]

default['pg']['base'] = '/data/postgresql'
default['pg']['log']  = '/data/log'
default['pg']['bin']  = '/usr/pgsql-10/bin'

default['pg']['hadr']['base_bkp'] = '/data/basebackup'
default['pg']['hadr']['wal_archive'] = '/data/wal_archive'
