#
# Cookbook Name::nginx 
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir     = '/usr/local/src'
version         = node['nginx']['version']
source_url      = node['nginx']['source_url']
centos_version  = node['nginx']['centos_version']
cpu             = node['nginx']['cpu']
template        = node['nginx']['template']

node['nginx']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/nginx-#{version}.el#{centos_version}.ngx.#{cpu}.rpm" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/nginx-#{version}.el#{centos_version}.ngx.#{cpu}.rpm"
  source "#{source_url}"
end

bash 'install_nginx' do
  not_if "rpm -qa | grep nginx"
  user 'root'

  code <<-EOL
    sudo rpm -ivh #{Chef::Config[:file_cache_path]}/nginx-#{version}.el#{centos_version}.ngx.#{cpu}.rpm
    sudo yum install nginx
  EOL
end

template "/etc/nginx/conf.d/#{node['nginx']['application_name']}.conf" do
  source "#{node['nginx']['template']}"
  owner 'nginx'
  group 'nginx'

  variables ({
    :server_name      => node['nginx']['server_name'],
    :server_port      => node['nginx']['server_port'],
    :application_name => node['nginx']['application_name'],
  })
end

bash 'create_www' do
  not_if "test -e /var/www"
  user  'root'

  code <<-EOL
    sudo mkdir -p /var/www
    sudo chgrp -R nginx /var/www
    sudo chmod -R 775 /var/www
  EOL
end

service 'nginx' do
  action [:start, :enable]
end
