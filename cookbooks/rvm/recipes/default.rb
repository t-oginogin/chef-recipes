#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_version     = node['rvm']['ruby_version']

bash 'install_rvm' do
  not_if "test -e ~/.rvm"
  user 'vagrant'
  group 'vagrant'

  code <<-EOL
    curl -L https://get.rvm.io | bash -s stable
    source ~/.bash_profile
  EOL
end

bash 'install_ruby' do
  not_if "test -e ~/.rvm/rubies/ruby-#{ruby_version}*"
  user 'vagrant'
  group 'vagrant'

  code <<-EOL
    source ~/.bash_profile
    rvm install #{ruby_version}
    rvm use #{ruby_version} --default
  EOL
end

bash 'set ruby version' do
  user 'vagrant'
  group 'vagrant'
  code <<-EOL
    source ~/.bash_profile
    rvm use #{ruby_version} --default
  EOL
end

gem_package 'bundler' do
  gem_binary "~/.rvm/bin/gem"
  action :upgrade
end

gem_package 'rails' do
  gem_binary "~/.rvm/bin/gem"
  action :upgrade
end

