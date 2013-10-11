#
# Cookbook Name:: mysql 
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'

mysql_source_url = node['mysql']['source_url']
mysql_version = node['mysql']['tar_file']

remote_file "#{Chef::Config[:file_cache_path]}/#{node['mysql']['tar_file']}" do
  not_if 'which mysql'
  not_if "test -e #{Chef::Config[:file_cache_path]}/#{node['mysql']['tar_file']}"
  user "root"
  source "#{mysql_source_url}/#{node['mysql']['tar_file']}"
end

bash 'get_mysql_rpm' do
  not_if 'which mysql'
  user "root"
  code <<-EOL
    cd #{Chef::Config[:file_cache_path]}
    tar xvf #{node['mysql']['tar_file']}
#    rm -rf #{node['mysql']['tar_file']}
  EOL
end

template '/usr/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode 644
  
  variables ({
    :character_set_server     => node['mysql']['character_set_server'],
  })
end

node['mysql']['install_rpms'].each do |rpm|
  package "#{rpm[:package_name]}" do
    not_if "rpm -qa | grep #{rpm[:rpm_file]}"
    action :install
    provider Chef::Provider::Package::Rpm
    source "#{Chef::Config[:file_cache_path]}/#{rpm[:rpm_file]}"
  end
end

service 'mysql' do
  action [:start, :enable]
end

bash "secure_install" do
  not_if 'which mysql'
  user "root"
  not_if "mysql -u root -pyour_password -e 'show databases;'"

  code <<-EOL
    export MYSQL_PASSWD=`head -n 1 ~/.mysql_secret |awk '{print $(NF - 0)}'`
    mysql -u root -p${MYSQL_PASSWD} --connect-expired-password -e "set password for root@localhost=password('your_password');"
    mysql -u root -pyour_password -e "set password for root@'localhost'=password('your_password');"
    mysql -u root -pyour_password -e "delete from mysql.user where user='';"
    mysql -u root -pyour_password -e "delete from mysql.user where user='root' and host not in ('localhost', '127.0.0.1');"
    mysql -u root -pyour_password -e "drop database test;"
    mysql -u root -pyour_password -e "delete from mysql.db where db='test' or db='test\\_%';"
    mysql -u root -pyour_password -e "flush privileges;"
    rm ~/.mysql_secret
  EOL
end

bash "initialize db for application" do
  user "root"
  not_if "mysql -u root -pyour_password -e 'show databases' | grep 'test_app'"

  code <<-EOL
    mysql -u root -pyour_password -e "create database test_app_development default character set utf8 collate utf8_unicode_ci;"
    mysql -u root -pyour_password -e "create database test_app_test default character set utf8 collate utf8_unicode_ci;"
    mysql -u root -pyour_password -e "create database test_app_production default character set utf8 collate utf8_unicode_ci;"
    mysql -u root -pyour_password -e "grant all on test_app_development.* to 'root'@'localhost';"
    mysql -u root -pyour_password -e "grant all on test_app_test.* to 'root'@'localhost';"
    mysql -u root -pyour_password -e "grant all on test_app_production.* to 'root'@'localhost';"
    mysql -u root -pyour_password -e "flush privileges;"
  EOL
end
