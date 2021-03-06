
default['general']['template_header'] = "# 
# This file is managed by chef
# Changes will be overwritten
#"

require 'csv'

pg_root = '/data'
default['pg']['root'] = pg_root

pg_conf_dir  = "#{pg_root}/conf"
pg_base      = "#{pg_root}/base"
pg_log       = "#{pg_root}/log"
resource_dir = File.dirname(File.expand_path(__FILE__))+ '/../resources/'
hba_csv      = File.read(resource_dir + 'pg_hba.conf.csv')

default['pg']['base'] = "#{pg_base}"
default['pg']['log']  = "#{pg_log}"
default['pg']['etc']  = "#{pg_root}/etc"
default['pg']['bin']  = '/usr/pgsql-10/bin'

default['pg']['conf']['dir']           = "#{pg_conf_dir}"
default['pg']['conf']['file']['path']  = "#{pg_conf_dir}/postgresql.conf"
default['pg']['conf']['file']['lines'] = [
    {key: 'data_directory', value: "#{pg_base}/"},
    {key: 'hba_file',       value: "#{pg_conf_dir}/pg_hba.conf"},
    {key: 'ident_file',     value: "#{pg_conf_dir}/pg_ident.conf"},
# TODO: segregate static conf. vals to .csv resource
# TODO: refactor conf dictionary to hash of type {:key, :value} 
#         (instead of {key: foo, value: bar} )
    {key: 'track_commit_timestamp', value: 'on'},
# host->guest is always 10.0.2.15 for test kitchen
#   https://superuser.com/a/310745/457020
    {key: 'listen_addresses',       value: 'localhost,10.0.2.15'} 
]

default['pg']['conf']['hba']['path']    = "#{pg_conf_dir}/pg_hba.conf"
default['pg']['conf']['hba']['records'] = []
hba_cols = CSV.parse_line(hba_csv)
hba_hash = CSV.parse(hba_csv).map {|a| Hash[hba_cols.zip(a)]}
hba_hash.shift # trim header tuple
hba_hash.each do |record|
    default['pg']['conf']['hba']['records'] << record
end
