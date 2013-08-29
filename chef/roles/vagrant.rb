name "vagrant"
description 'This is a custom role for Vagrant to use'
run_list(
    "recipe[apt]",
    "recipe[runit]",
    "recipe[unattended-upgrades]",
    "recipe[redis::server]",
    "recipe[build-essential]",
    "recipe[ruby_build]", 
    "recipe[bundler]",
    "recipe[rbenv::system]",
    "recipe[postgresql::server]",
    "recipe[rails]",
    "recipe[custom]"
)

override_attributes(
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
    server: { packages: %w{postgresql postgresql-contrib} },
    pg_hba: [
      {type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'ident' },
      {type: 'host', db: 'all', user: 'postgres', addr: 'localhost', method: 'md5'}
    ]
  }
)

