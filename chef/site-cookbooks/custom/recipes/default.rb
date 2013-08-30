# install some packages
packages = [
  "sl",
  "colordiff",
  "byobu",
  "git",
]

packages.each do |p|
  package p
end

user 'web_user' do
  home "/home/web_user"
  shell "/bin/bash"
  supports manage_home: true
end

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
  variables keys: data_bag_item('users', 'deploy')["ssh_keys"]
end

include_recipe "postgresql::ruby"

directory "#{node['custom']['cap_base']}" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

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

template "#{node['custom']['deploy_to']}/shared/database.yml" do
  source 'database.yml.erb'
  owner "web_user"
  group "web_user"
  mode "0644"
end

postgresql_connection_info = {:host => "localhost",
                              :port => 5432,
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

postgresql_database "#{node['custom']['database']}" do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user 'web_user' do
  connection postgresql_connection_info
  password "#{node['custom']['database_password']}"
  action :create
end

postgresql_database_user 'web_user' do
  connection postgresql_connection_info
  database_name "#{node['custom']['database']}"
  privileges [:all]
  action :grant
end
