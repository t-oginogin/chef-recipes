#
# Cookbook Name::git 
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'
version     = node['git']['version']
source_uri  = node['git']['source_uri']
configure   = node['git']['configure']

node['git']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

remote_file "/tmp/git-#{version}.tar.gz" do
  not_if 'which git'
  source "#{source_uri}"
end

bash 'install_git' do
  not_if 'which git'
  user 'root'

  code <<-EOL
    install -d #{install_dir}
    tar xfz /tmp/git-#{version}.tar.gz -C #{install_dir}
    rm -rf /tmp/git-#{version}.tar.gz
    cd #{install_dir}/git-#{version}
    #{configure} && make && make install && make clean
  EOL
end
