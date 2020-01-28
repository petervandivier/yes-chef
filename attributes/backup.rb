
require 'csv'

pg_root = node['pg']['root']

bkp_root = "#{pg_root}/bkp"
# wal_arch = "#{bkp_root}/wal"
resource_dir = File.dirname(File.expand_path(__FILE__))+ '/../resources/backup/'
hba_csv = File.read(resource_dir + 'pg_hba.conf.csv')

default['pg']['hadr']['base_bkp']    = "#{bkp_root}/base"
default['pg']['hadr']['wal_archive'] = "#{bkp_root}/wal"
default['pg']['hadr']['tar_dir']     = "#{pg_root}/tar"
default['pg']['hadr']['untar_dir']   = "/tmp/pg_wal"

default['pg']['hadr']['name_fmt_py'] = "%Y%m%d%H%M%S"
default['pg']['hadr']['name_fmt_sh_cmd'] = 'date -u +%Y%m%d%H%M%S%z'
default['pg']['hadr']['retention_days'] = 7

hba_cols = CSV.parse_line(hba_csv)
hba_hash = CSV.parse(hba_csv).map {|a| Hash[hba_cols.zip(a)]}
hba_hash.shift # trim header tuple
hba_hash.each do |record|
    default['pg']['conf']['hba']['records'] << record
end
