name "vagrant"
description 'This is a custom role for Vagrant to use'
run_list(
    "recipe[apt]",
    "recipe[runit]",
    "recipe[unattended-upgrades]",
    "recipe[redis::server]",
    "recipe[build-essential]",
    "recipe[statsd]",
    "recipe[phantomjs]",
    "recipe[ruby_build]", 
    "recipe[bundler]",
    #"recipe[rbenv::user_install]",
    "recipe[rails]",
    "recipe[custom]"
)

override_attributes(
  :unattended_upgrades => {
    "allowed_origins" => ['${distro_id}:${distro_codename}-security'],
    "mail" => nil
  },
  :rbenv => {
   "rubies" => "2.0.0-p247"
  }
)

