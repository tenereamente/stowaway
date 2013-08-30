set :user, 'vagrant'
set :sudo_user, 'web_user'
server 'stowaway_development', :web, :app, :db, :primary => true
set :port, 2222

set :deploy_to, '/app/dev'
set :rails_env, 'development'
