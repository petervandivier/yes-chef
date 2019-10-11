#!/usr/bin/env bash

if [ `whoami` != 'root' ]
then
# https://stackoverflow.com/a/5947802/4709762
    RED='\033[0;31m'
    NC='\033[0m'
    echo -e "${RED}must be executed as root${NC}"
    exit
fi

pushd /usr/local/share/ > /dev/null

mkdir sysbench-out 
cd sysbench-out

sysbench fileio prepare 
sysbench fileio run --file-test-mode=rndrw > fileio.rndrw.out
rm -f test_file*

sysbench cpu     run > cpu.out
sysbench memory  run > memory.out
sysbench threads run > threads.out
sysbench mutex   run > mutex.out

sysbench \
  --db-driver=pgsql \
  --oltp-table-size=10000 \
  --oltp-tables-count=24 \
  --threads=1 \
  --pgsql-host=127.0.0.1 \
  --pgsql-port=5432 \
  --pgsql-user=sbtest \
  --pgsql-password=password \
  --pgsql-db=sbtest \
  /usr/share/sysbench/tests/include/oltp_legacy/parallel_prepare.lua \
run > oltp_legacy.out

sysbench \
  --db-driver=pgsql \
  --oltp-tables-count=24 \
  --pgsql-host=127.0.0.1 \
  --pgsql-port=5432 \
  --pgsql-user=sbtest \
  --pgsql-password=password \
  --pgsql-db=sbtest \
  /usr/share/sysbench/tests/include/oltp_legacy/parallel_prepare.lua \
cleanup

cd ../sysbench-tpcc

chmod -R 0777 sysbench-out
mv sysbench-out /tmp

popd > /dev/null

# https://unix.stackexchange.com/a/37414/348605
: <<'REM'
sysbench \
  --db-driver=pgsql \
  --oltp-table-size=100000 \
  --oltp-tables-count=24 \
  --threads=1 \
  --pgsql-host=127.0.0.1 \
  --pgsql-port=5432 \
  --pgsql-user=sbtest \
  --pgsql-password=password \
  --pgsql-db=sbtest \
  /usr/share/sysbench/tests/include/oltp_legacy/parallel_prepare.lua \
run
REM
