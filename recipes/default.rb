
# https://serverfault.com/a/627682/401889
template '/etc/profile.d/bash_profile.sh' do 
    source 'bash_profile.sh'
end

# https://stackoverflow.com/a/45745410/4709762
yum_package 'epel-release' do
end
yum_package 'jq' do
end
