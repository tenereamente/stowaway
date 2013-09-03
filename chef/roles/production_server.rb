name "production_server"
description 'This is a custom role for chef-solo on the production server'
run_list("role[vagrant]", "recipe[custom::production_server]", "recipe[custom::staging_server]")

secret = File.read(Pathname.new(File.expand_path(File.dirname(__FILE__))) + "../.chef/encrypted_data_bag_secret")
passwords = Chef::EncryptedDataBagItem.load("custom", "secrets", secret)

override_attributes(
  :postgresql => {
	password: { postgres: passwords['prod']['postgresql'] },
    pg_hba: [
      {type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'ident' },
      {type: 'host', db: 'all', user: 'all', addr: 'localhost', method: 'md5'}
    ],
    config_pgtune: { db_type: 'web', max_connections: '50', total_memory: '131072kB' }
  },
  openssh: {
    permit_root_login: "no",
    password_authentication: "no"
  },
  authorization: {
    sudo: {
      users: [ 'web_user' ],
      passwordless: true
    }
  },
  :custom => {
    :deploy_to => '/app/production',
    :database => 'stowaway_production',
    :rails_environment => 'production',
    :database_user => 'web_user',
    :database_password => passwords['prod']['web_user'],
    :database_host => 'localhost'
  }
)

