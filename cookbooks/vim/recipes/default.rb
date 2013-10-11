#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'

mq_source_url = node['vim']['mq_source_url']
mq_package = node['vim']['mq_package']

node['vim']['packages'].each do |package_name|
  package "#{package_name}" do
    :install
  end
end

#mercurial
remote_file "#{Chef::Config[:file_cache_path]}/#{mq_package}" do
  not_if 'which hg'
  source "#{mq_source_url}/#{mq_package}"
end

bash 'install mercurial' do
  not_if 'which hg'
  user 'root'
  code <<-EOL
    rpm -Uvh --nosignature #{Chef::Config[:file_cache_path]}/#{mq_package}
    rm -rf #{Chef::Config[:file_cache_path]}/#{mq_package}
  EOL
end

#vim
bash 'install_vim' do
  not_if 'which vim'
  user 'root'

  code <<-EOL
    cd #{install_dir}
    hg clone https://vim.googlecode.com/hg/ vim
    cd #{install_dir}/vim
    ./configure --enable-multibyte --with-features=huge --disable-selinux --prefix=/usr/local
    make && make install && make clean
    cd ../
    rm -rf vim
  EOL
end

