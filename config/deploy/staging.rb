set :user, 'web_user'
set :sudo_user, 'root'
# staging.stowaway.co digital ocean server'
server '192.241.165.112', :web, :app, :db, :primary => true
set :port, 22

set :deploy_to, '/app/staging'
set :rails_env, 'staging'
set :vhost, 'staging.stowaway.co'