#
# Cookbook Name::git 
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'
curl_version     = node['git']['curl_version']
curl_source_uri  = node['git']['curl_source_uri']
version     = node['git']['version']
source_uri  = node['git']['source_uri']

node['git']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/curl-#{curl_version}.tar.bz2" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/curl-#{curl_version}.tar.bz2"
  source "#{curl_source_uri}"
end

bash 'install_curl' do
  not_if 'test -e /usr/local/curl'
  user 'root'

  code <<-EOL
    install -d #{install_dir}
    tar xf #{Chef::Config[:file_cache_path]}/curl-#{curl_version}.tar.bz2 -C #{install_dir}
    cd #{install_dir}/curl-#{curl_version}
    ./configure --prefix=/usr/local/curl
    make && make install && make clean
    alias curl='/usr/local/curl/bin/curl'
  EOL
end

remote_file "#{Chef::Config[:file_cache_path]}/git-#{version}.tar.gz" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/git-#{version}.tar.gz"
  source "#{source_uri}"
end

bash 'install_git' do
  not_if 'which git'
  user 'root'

  code <<-EOL
    install -d #{install_dir}
    tar xfz #{Chef::Config[:file_cache_path]}/git-#{version}.tar.gz -C #{install_dir}
    cd #{install_dir}/git-#{version}
    ./configure --with-curl=/usr/local/curl
    make && make install && make clean
  EOL
end
