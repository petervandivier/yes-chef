
postgresql_server_install 'Install' do
    version '11'
    initdb_locale 'en_GB.UTF-8' 
    action [:install, :create]
end
