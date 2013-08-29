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

