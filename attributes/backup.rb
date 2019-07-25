
default['pg']['hadr']['base_bkp'] = '/data/bkp'
default['pg']['hadr']['wal_archive'] = '/data/walarch'

# TODO: how to append attrid to dict in-flight?
# currently un-commenting this block overwrites attribs from the default dict
# default['pg']['conf']['hba']['records'] = [
#     {type: 'local', db: 'replication', user: 'postgres', method: 'peer',                           comment: 'required for basebackup'}
# ]
