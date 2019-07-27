
default['pg']['hadr']['base_bkp'] = '/data/bkp/base'
default['pg']['hadr']['wal_archive'] = '/data/bkp/wal'

default['pg']['hadr']['name_fmt'] = 'date -u +%Y%m%d%H%M%S%z'
default['pg']['hadr']['retention_days'] = 7
