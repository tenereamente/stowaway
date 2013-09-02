require 'bundler/capistrano'
require 'capistrano/ext/multistage'

load 'config/cap_tasks/base'
load 'config/cap_tasks/nginx'
load 'config/cap_tasks/unicorn'
load 'config/cap_tasks/monit'

set :stages, %w(production staging development)
set :default_stage, "staging"

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH',
  'RBENV_ROOT' => '/usr/local/rbenv'
}

set :application, 'stowaway'

set :scm, :git
set :repository,  'git@github.com:statik/StowAway.git'
set :branch, :master
set :deploy_via, :remote_cache

set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

set :use_sudo, false
set :group_writeable, false
set :normalize_asset_timestamps, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :target_os, :ubuntu

namespace :custom do
  desc 'Shared storage folders and symlinks to the release'
  task :file_system, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config"
    run "test -f #{shared_path}/config/SECRET_KEY_BASE || cd #{release_path} && bundle exec rake secret > #{shared_path}/config/SECRET_KEY_BASE"
    run "ln -nfs #{shared_path}/config/SECRET_KEY_BASE #{release_path}/config"
  end

end

# --------------------------------------------
# Overloaded tasks
# --------------------------------------------
namespace :deploy do
  desc <<-DESC
    Prepares one or more servers for deployment. Before you can use any \
    of the Capistrano deployment tasks with your project, you will need to \
    make sure all of your servers have been prepared with `cap deploy:setup'. When \
    you add a new server to your cluster, you can easily run the setup task \
    on just that server by specifying the HOSTS environment variable:

      $ cap HOSTS=new.server.com deploy:setup

    It is safe to run this task on servers that have already been set up; it \
    will not destroy any deployed revisions or data.
  DESC
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')}"
    run "#{try_sudo} chmod 755 #{dirs.join(' ')}" if fetch(:group_writeable, true)
  end
  
  desc "Setup shared application directories and permissions after initial setup"
  task :setup_shared do
    puts "STUB: Setup"
  end

  desc "Setup backup directory for database and web files"
  task :setup_backup, :except => { :no_release => true } do
    run "#{try_sudo} mkdir -p #{backups_path} && #{try_sudo} chmod g+w #{backups_path}"
  end
end

#before 'bundle:install', 'custom:rbenv_version'
after 'deploy:update_code', 'custom:file_system'
after 'deploy:restart', 'deploy:cleanup'

