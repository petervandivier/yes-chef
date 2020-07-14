
describe command('systemctl status elasticsearch') do
    its('stdout') { should match /active \(running\)/}
end

describe command("curl http://127.0.0.1:9200 -s | jq '.tagline'") do
    its('stdout') { should cmp /You Know, for Search/}
end
