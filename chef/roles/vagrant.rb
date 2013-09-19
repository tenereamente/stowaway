name "vagrant"
description 'This is a custom role for Vagrant to use'
run_list(
    "recipe[build-essential]",
    #"recipe[annoyances]",
    "recipe[openssl]",
    "recipe[openssh]",
    "recipe[sudo]",
    "recipe[apt]",
    "recipe[runit]",
    "recipe[unattended-upgrades]",
    "recipe[redis::server]",
    "recipe[ruby_build]", 
    "recipe[bundler]",
    "recipe[rbenv::system]",
    "recipe[htop]",
    "recipe[fail2ban]",
    "recipe[ufw]",
    "recipe[nginx]",
    "recipe[monit]",
    "recipe[database]",
    "recipe[postgresql::server]",
    "recipe[postgresql::contrib]",
    "recipe[postgresql::config_pgtune]",
    "recipe[rails]",
    "recipe[phantomjs]",
    "recipe[python]",
    "recipe[tarsnap]",
    "recipe[tarsnap::tarsnapper]"
)

default_attributes(
  :unattended_upgrades => {
    "allowed_origins" => ['${distro_id}:${distro_codename}-security'],
    "mail" => nil
  },
  :rbenv => {
    rubies: "2.0.0-p247",
    global: "2.0.0-p247",
    gems: {'2.0.0-p247' => [{ name: 'bundler' }]}
  },
  :postgresql => {
    password: { postgres: "totallyinsecure" },
    pg_hba: [
      {type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'ident' },
      {type: 'host', db: 'all', user: 'postgres', addr: 'localhost', method: 'md5'}
    ],
    config_pgtune: { db_type: 'desktop', max_connections: '5', total_memory: '131072kB' }
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
    :database => 'stowaway_development',
    :rails_environment => 'development',
    :database_user => 'web_user',
    :database_password => 'insecure',
    :database_host => 'localhost'
  }
)

