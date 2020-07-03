#!/usr/bin/env bash

template '/tmp/make-elastic.sh' do
    source 'elasticsearch/make-elastic.sh'
    mode 0o744
end

execute 'Initialize ES & Kibana' do
    command '/tmp/make-elastic.sh'
    live_stream true
    user 'root'
    creates '/etc/kibana/kibana.yml'
end
