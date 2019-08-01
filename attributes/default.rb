
pg_conf_path = '/data/conf'
pg_base = '/data/base'
pg_log = '/data/log'

default['pg']['base'] = "#{pg_base}"
default['pg']['log']  = "#{pg_log}"
default['pg']['etc']  = '/data/etc'
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
default['pg']['conf']['hba']['records'] = []

require 'csv'
hba_csv = File.read(File.dirname(File.expand_path(__FILE__)) + '/../resources/pg_hba.conf.csv')
hba_cols = CSV.parse_line(hba_csv)
hba_hash = CSV.parse(hba_csv).map {|a| Hash[hba_cols.zip(a)]}
hba_hash.shift # trim header tuple
hba_hash.each do |record|
    default['pg']['conf']['hba']['records'] << record
end
