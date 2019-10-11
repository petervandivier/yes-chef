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

curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | bash

yum -y install sysbench
yum -y install git
git clone https://github.com/Percona-Lab/sysbench-tpcc.git

popd > /dev/null
