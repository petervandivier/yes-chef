
wal_arch = '/data/bkp/wal'

default['pg']['hadr']['base_bkp'] = '/data/bkp/base'
default['pg']['hadr']['wal_archive'] = "#{wal_arch}"

default['pg']['hadr']['name_fmt'] = 'date -u +%Y%m%d%H%M%S%z'
default['pg']['hadr']['retention_days'] = 7
