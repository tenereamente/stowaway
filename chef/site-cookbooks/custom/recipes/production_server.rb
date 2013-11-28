# install some packages
packages = [
  "sl",
  "colordiff",
  "tmux",
  "git",
  "vim-nox",
  "build-essential",
  "imagemagick",
  "htop",
  "bmon"
]

packages.each do |p|
  package p
end

user 'web_user' do
  home "/home/web_user"
  shell "/bin/bash"
  supports manage_home: true
end

#group "admin" do
#  append true
#  action :modify
#  members "web_user"
#end

directory "/home/web_user/.ssh" do
  action :create
  owner 'web_user'
  group 'web_user'
  mode '0700'
end

template "home/web_user/.ssh/authorized_keys" do
  source 'authorized_keys.erb'
  owner "web_user"
  group "web_user"
  mode "0600"
  variables keys: data_bag_item('users', 'production_deploy')["ssh_keys"]
end

include_recipe "postgresql::ruby"

directory "/app" do
  action :create
  owner "web_user"
  group "web_user"
  mode "0775"
end

# This section is set to /app/production
directory "#{node['custom']['deploy_to']}" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/shared" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/shared/system" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/shared/config" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/shared/log" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/shared/pids" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "#{node['custom']['deploy_to']}/releases" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

template "#{node['custom']['deploy_to']}/shared/config/database.yml" do
  source 'database.yml.erb'
  owner "web_user"
  group "web_user"
  mode "0644"
end

secret = File.read(Pathname.new(File.expand_path(File.dirname(__FILE__))) + "../../../.chef/encrypted_data_bag_secret")
passwords = Chef::EncryptedDataBagItem.load("custom", "secrets", secret)


postgresql_connection_info = {:host => "localhost",
                              :port => 5432,
                              :username => 'postgres',
                              :password => passwords['prod']['postgresql']}

template "#{node['custom']['deploy_to']}/shared/config/application.yml" do
  source 'application.yml.erb'
  owner "web_user"
  group "web_user"
  mode "0644"
  variables mandrill_api_key: passwords['prod']['mandrill_api_key'],
            mandrill_username: passwords['prod']['mandrill_username'],
            mailchimp_api_key: passwords['prod']['mailchimp_api_key'],
            facebook_app_id: passwords['prod']['facebook_app_id'],
            facebook_app_secret: passwords['prod']['facebook_app_secret'],
            aws_access_key_id: passwords['prod']['aws_access_key_id'],
            aws_secret_access_key: passwords['prod']['aws_secret_access_key'],
            aws_bucket: "stowawayco-production",
            stripe_pk: passwords['prod']['stripe_live_pk'],
            stripe_sk: passwords['prod']['stripe_live_sk'],
            getsentry_key: passwords['prod']['getsentry_key'],
            customerio_api_key: passwords['prod']['customerio_api_key'],
            devise_secret_key: passwords['prod']['devise_secret_key']

end

directory "/etc/nginx/ssl" do
  mode "0600"
  owner "web_user"
  group "web_user"
end

file "/root/tarsnap.key" do
  mode "0600"
  owner "root"
  group "root"
  content passwords['prod']['tarsnap']
end

cron_d 'postgres-backups' do
  minute  0
  hour    23
  command 'sudo -u postgres /usr/bin/pg_dumpall > /app/dailydbbackup.sql && tarsnapper --target "stowaway-db-\$date" --sources "/app" --deltas 1d 7d 30d - make'
end

file "/etc/nginx/ssl/stowaway_production.crt" do
  mode "0600"
  content passwords['prod']['production_ssl_certs']
  owner "web_user"
  group "web_user"
end

file "/etc/nginx/ssl/stowaway_production.key" do
  mode "0600"
  content passwords['prod']['production_ssl_key']
  owner "web_user"
  group "web_user"
end

postgresql_database "#{node['custom']['database']}" do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user 'web_user' do
  connection postgresql_connection_info
  password passwords['prod']['web_user']
  action :create
end

postgresql_database_user 'web_user' do
  connection postgresql_connection_info
  database_name "#{node['custom']['database']}"
  privileges [:all]
  action :grant
end

firewall_rule "http/https" do
  protocol :tcp
  ports [ 80, 443 ]
  action :allow
end
