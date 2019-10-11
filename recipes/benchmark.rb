
# sysbench tpcc directory
sbt_dir="benchmark/sysbench/tpcc"

template '/tmp/init-sysbench-tpcc.sh' do
    mode 0o700
    source "#{sbt_dir}/init.sh"
    action :create
end

template '/tmp/run-sysbench-out.sh' do
    mode 0o700
    source "#{sbt_dir}/run.sh"
    action :create
end
