set :user, 'web_user'
set :sudo_user, 'root'
# stowaway.co digital ocean server'
server '162.243.22.155', :web, :app, :db, :primary => true
set :port, 22

set :deploy_to, '/app/production'
set :rails_env, 'production'
set :vhost, 'www.stowaway.co'