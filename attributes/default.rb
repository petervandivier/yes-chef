
default['pg']['conf']['path']          = '/data/conf/'
default['pg']['conf']['file']['path']  = '/data/conf/postgresql.conf'
default['pg']['conf']['file']['lines'] = [
# FILE LOCATIONS
    {key: 'data_directory', value: '/data/base/'},
    {key: 'hba_file',       value: '/data/conf/pg_hba.conf'},
    {key: 'ident_file',     value: '/data/conf/postgresql.conf'}
]
default['pg']['conf']['hba']['path']    = '/data/conf/pg_hba.conf'
default['pg']['conf']['hba']['records'] = [
    {type: 'local', db: 'all',         user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'postgres', method: 'peer',                           comment: 'required for basebackup'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '127.0.0.1/32', comment: 'IPv4 local connections:'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '::1/128',      comment: 'IPv6 local connections:'},
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '127.0.0.1/32'}, 
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '::1/128'}
]

default['pg']['base'] = '/data/base'
default['pg']['log']  = '/data/log'
default['pg']['bin']  = '/usr/pgsql-10/bin'

default['pg']['hadr']['base_bkp'] = '/data/bkp'
default['pg']['hadr']['wal_archive'] = '/data/walarch'
