name "production_server"
description 'This is a custom role for chef-solo on the production server'
run_list("role[vagrant]", "recipe[custom::production_server]")

# TODO
# secure / encrypted postgres password
# secure / encrypted rails cookie
# make sure vagrant insecure key is not installed
# sudo permissions for web_user

override_attributes(
  :postgresql => {
    password: { postgres: "totallyinsecure" }, # TODO FIX THIS PASSWORD
    pg_hba: [
      {type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'ident' },
      {type: 'host', db: 'all', user: 'postgres', addr: 'localhost', method: 'md5'}
    ],
    config_pgtune: { db_type: 'web', max_connections: '50', total_memory: '131072kB' }
  },
  openssh: {
    permit_root_login: "no",
    password_authentication: "no"
  },
  authorization: {
    sudo: {
      groups: [
        :admin,
        :sudo
      ],
      passwordless: true
    }
  },
  :custom => {
    :deploy_to => '/app/dev',
    :database => 'stowaway_production',
    :rails_environment => 'production',
    :database_user => 'web_user',
    :database_password => 'insecure', # TOOO FIX THIS PASSWORD
    :database_host => 'localhost'
  }
)

