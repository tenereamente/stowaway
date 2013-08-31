set :user, 'web_user'
set :sudo_user, 'vagrant'
server 'stowaway_development', :web, :app, :db, :primary => true
set :port, 2222

set :deploy_to, '/app/dev'
set :rails_env, 'development'
