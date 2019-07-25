
pg_conf_path = '/data/conf'
pg_base = '/data/base'

default['pg']['base'] = "#{pg_base}"
default['pg']['log']  = '/data/log'
default['pg']['bin']  = '/usr/pgsql-10/bin'

default['pg']['conf']['path']          = "#{pg_conf_path}"
default['pg']['conf']['file']['path']  = "#{pg_conf_path}/postgresql.conf"
default['pg']['conf']['file']['lines'] = [
# FILE LOCATIONS
    {key: 'data_directory', value: "#{pg_base}/"},
    {key: 'hba_file',       value: "#{pg_conf_path}/pg_hba.conf"},
    {key: 'ident_file',     value: "#{pg_conf_path}/postgresql.conf"}
]
default['pg']['conf']['hba']['path']    = "#{pg_conf_path}/pg_hba.conf"
default['pg']['conf']['hba']['records'] = [
    {type: 'local', db: 'all',         user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'all',      method: 'trust'},
    {type: 'local', db: 'replication', user: 'postgres', method: 'peer',                           comment: 'required for basebackup'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '127.0.0.1/32', comment: 'IPv4 local connections:'},
    {type: 'host',  db: 'all',         user: 'all',      method: 'trust', address: '::1/128',      comment: 'IPv6 local connections:'},
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '127.0.0.1/32'}, 
    {type: 'host',  db: 'replication', user: 'all',      method: 'trust', address: '::1/128'}
]
