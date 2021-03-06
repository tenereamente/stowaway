include_recipe "postgresql::ruby"

directory "/app" do
  action :create
  owner "web_user"
  group "web_user"
  mode "0777"
end

directory "/app/staging" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/shared" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/shared/system" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/shared/config" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/shared/log" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/shared/pids" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

directory "/app/staging/releases" do
  action :create
  owner "web_user"
  group "web_user"
  mode '0755'
end

template "/app/staging/shared/config/database.yml" do
  source 'database.yml.erb'
  owner "web_user"
  group "web_user"
  mode "0644"
end

secret = File.read(Pathname.new(File.expand_path(File.dirname(__FILE__))) + "../../../.chef/encrypted_data_bag_secret")
passwords = Chef::EncryptedDataBagItem.load("custom", "secrets", secret)

template "/app/staging/shared/config/application.yml" do
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
            aws_bucket: "stowawayco-staging",
            stripe_pk: passwords['prod']['stripe_test_pk'],
            stripe_sk: passwords['prod']['stripe_test_sk'],
            getsentry_key: passwords['prod']['getsentry_key'],
            customerio_api_key: passwords['prod']['customerio_api_key'],
            devise_secret_key: passwords['prod']['devise_secret_key']
end

directory "/etc/nginx/ssl" do
  mode "0600"
  owner "web_user"
  group "web_user"
end

file "/etc/nginx/ssl/stowaway_staging.crt" do
  mode "0600"
  content passwords['prod']['staging_ssl_certs']
  owner "web_user"
  group "web_user"
end

file "/etc/nginx/ssl/stowaway_staging.key" do
  mode "0600"
  content passwords['prod']['staging_ssl_key']
  owner "web_user"
  group "web_user"
end


postgresql_connection_info = {:host => "localhost",
                              :port => 5432,
                              :username => 'postgres',
                              :password => passwords['prod']['postgresql']}

postgresql_database "stowaway_staging" do
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
  database_name "stowaway_staging"
  privileges [:all]
  action :grant
end
