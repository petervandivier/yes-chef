
require 'csv'

wal_arch = '/data/bkp/wal'
resource_dir = File.dirname(File.expand_path(__FILE__))+ '/../resources/backup/'
hba_csv = File.read(resource_dir + 'pg_hba.conf.csv')

default['pg']['hadr']['base_bkp'] = '/data/bkp/base'
default['pg']['hadr']['wal_archive'] = "#{wal_arch}"

default['pg']['hadr']['name_fmt'] = 'date -u +%Y%m%d%H%M%S%z'
default['pg']['hadr']['retention_days'] = 7

hba_cols = CSV.parse_line(hba_csv)
hba_hash = CSV.parse(hba_csv).map {|a| Hash[hba_cols.zip(a)]}
hba_hash.shift # trim header tuple
hba_hash.each do |record|
    default['pg']['conf']['hba']['records'] << record
end
