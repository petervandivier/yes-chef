
default['general']['template_header'] = "# 
# This file is managed by chef
# Changes will be overwritten
#"

require 'csv'

pg_conf_dir = '/data/conf'
pg_base = '/data/base'
pg_log = '/data/log'
resource_dir = File.dirname(File.expand_path(__FILE__))+ '/../resources/'
hba_csv = File.read(resource_dir + 'pg_hba.conf.csv')

default['pg']['base'] = "#{pg_base}"
default['pg']['log']  = "#{pg_log}"
default['pg']['etc']  = '/data/etc'
default['pg']['bin']  = '/usr/pgsql-10/bin'

default['pg']['conf']['dir']           = "#{pg_conf_dir}"
default['pg']['conf']['file']['path']  = "#{pg_conf_dir}/postgresql.conf"
default['pg']['conf']['file']['lines'] = [
    {key: 'data_directory', value: "#{pg_base}/"},
    {key: 'hba_file',       value: "#{pg_conf_dir}/pg_hba.conf"},
    {key: 'ident_file',     value: "#{pg_conf_dir}/postgresql.conf"},
# TODO: segregate static conf. vals to .csv resource
# TODO: refactor conf dictionary to hash of type {:key, :value} 
#         (instead of {key: foo, value: bar} )
    {key: 'track_commit_timestamp', value: 'on'}    
]

default['pg']['conf']['hba']['path']    = "#{pg_conf_dir}/pg_hba.conf"
default['pg']['conf']['hba']['records'] = []
hba_cols = CSV.parse_line(hba_csv)
hba_hash = CSV.parse(hba_csv).map {|a| Hash[hba_cols.zip(a)]}
hba_hash.shift # trim header tuple
hba_hash.each do |record|
    default['pg']['conf']['hba']['records'] << record
end
