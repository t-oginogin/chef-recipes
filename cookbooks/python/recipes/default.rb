#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'

source_url = node['python']['source_url']
version = node['python']['version']

# python
remote_file "#{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2"
  source "#{source_url}/#{version}/Python-#{version}.tar.bz2"
end

bash 'install_python' do
  not_if "test -e /usr/local/bin/python2.7"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xf #{Chef::Config[:file_cache_path]}/Python-#{version}.tar.bz2 -C #{install_dir}
    cd #{install_dir}/Python-#{version}
    ./configure
    make && make install && make clean
    alias python='/usr/local/bin/python2.7'
    alias python2='/usr/local/bin/python2.7'
  EOL
end


