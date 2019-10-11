#!/usr/bin/env bash

if [ `whoami` != 'root' ]
then
# https://stackoverflow.com/a/5947802/4709762
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}must be executed as root${NC}"
    exit
fi

# postgres
psql -U postgres -c "CREATE USER sbtest WITH PASSWORD 'password';"
createdb sbtest -U postgres -O sbtest
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sbtest TO sbtest;"

hba_file=`psql -U postgres -tc "show hba_file"`
data_dir=`psql -U postgres -tc "show data_directory"`
echo "host sbtest sbtest 10.0.0.0/8 md5" >> $hba_file

# ¿ /usr/pgsql-#{version}/bin/pg_ctl ?
sudo -u postgres /usr/pgsql-10/bin/pg_ctl reload -D $data_dir

popd > /dev/null
