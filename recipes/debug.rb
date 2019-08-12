
require 'json'

file '/tmp/dict.json' do
    content "#{node['pg'].to_json}"
end

group 'postgres' do
    append true
    members %w(vagrant)
    action :modify
end
