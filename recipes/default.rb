
# https://serverfault.com/a/627682/401889
if node['platform_family'] == 'rhel'
    template '/etc/profile.d/bash_profile.sh' do 
        source 'bash_profile.sh'
    end

    package 'epel-release' do 
        action :install
    end
end

%w[
    jq
    bash
].each do |pkg|
    package pkg do 
        action :install
    end
end
