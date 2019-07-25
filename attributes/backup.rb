
default['pg']['hadr']['base_bkp'] = '/data/bkp/base'
default['pg']['hadr']['wal_archive'] = '/data/bkp/wal'

# TODO: how to append attrid to dict in-flight?
# currently un-commenting this block overwrites attribs from the default dict
# default['pg']['conf']['hba']['records'] = [
#     {type: 'local', db: 'replication', user: 'postgres', method: 'peer',                           comment: 'required for basebackup'}
# ]

default['pg']['hadr']['name_fmt'] = 'date -u +%Y%m%d%H%M%S%z'
default['pg']['hadr']['retention_days'] = 7
