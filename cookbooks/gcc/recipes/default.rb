#
# Cookbook Name:: gcc
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

install_dir = '/usr/local/src'

m4_source_url = node['gcc']['m4_source_url']
m4_version = node['gcc']['m4_version']
gmp_source_url = node['gcc']['gmp_source_url']
gmp_version = node['gcc']['gmp_version']
mpfr_source_url = node['gcc']['mpfr_source_url']
mpfr_version = node['gcc']['mpfr_version']
mpc_source_url = node['gcc']['mpc_source_url']
mpc_version = node['gcc']['mpc_version']
ppl_source_url = node['gcc']['ppl_source_url']
ppl_version = node['gcc']['ppl_version']
cloog_source_url = node['gcc']['cloog_source_url']
cloog_version = node['gcc']['cloog_version']
gcc_source_url = node['gcc']['gcc_source_url']
gcc_version = node['gcc']['gcc_version']

#g++
package "gcc-c++" do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  :install
end

# m4
remote_file "#{Chef::Config[:file_cache_path]}/m4-#{m4_version}.tar.bz2" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/m4-#{m4_version}.tar.bz2"
  source "#{m4_source_url}"
end

bash 'install_m4' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xf #{Chef::Config[:file_cache_path]}/m4-#{m4_version}.tar.bz2 -C #{install_dir}
    cd #{install_dir}/m4-#{m4_version}
    ./configure --prefix=/usr/local/gcc
    make && make install && make clean
  EOL
end

# gmp
remote_file "#{Chef::Config[:file_cache_path]}/gmp-#{gmp_version}.tar.gz" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/gmp-#{gmp_version}.tar.gz"
  source "#{gmp_source_url}"
end

bash 'install_gmp' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xfz #{Chef::Config[:file_cache_path]}/gmp-#{gmp_version}.tar.gz -C #{install_dir}
    cd #{install_dir}/gmp-#{gmp_version}
    CPPFLAGS=-fexceptions M4=/usr/local/gcc/bin/m4 ./configure --prefix=/usr/local/gcc --enable-cxx
    make && make install && make clean
  EOL
end

# mpfr 
remote_file "#{Chef::Config[:file_cache_path]}/mpfr-#{mpfr_version}.tar.gz" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/mpfr-#{mpfr_version}.tar.gz"
  source "#{mpfr_source_url}"
end

bash 'install_mpfr' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xfz #{Chef::Config[:file_cache_path]}/mpfr-#{mpfr_version}.tar.gz -C #{install_dir}
    cd #{install_dir}/mpfr-#{mpfr_version}
    ./configure --prefix=/usr/local/gcc --with-gmp=/usr/local/gcc
    make && make install && make clean
  EOL
end

# mpc 
remote_file "#{Chef::Config[:file_cache_path]}/mpc-#{mpc_version}.tar.gz" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/mpc-#{mpc_version}.tar.gz"
  source "#{mpc_source_url}"
end

bash 'install_mpc' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xfz #{Chef::Config[:file_cache_path]}/mpc-#{mpc_version}.tar.gz -C #{install_dir}
    cd #{install_dir}/mpc-#{mpc_version}
    ./configure  --prefix=/usr/local/gcc --with-gmp=/usr/local/gcc --with-mpfr=/usr/local/gcc
    make && make install && make clean
  EOL
end

# ppl
remote_file "#{Chef::Config[:file_cache_path]}/ppl-#{ppl_version}.tar.bz2" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/ppl-#{ppl_version}.tar.bz2"
  source "#{ppl_source_url}"
end

bash 'install_ppl' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xf #{Chef::Config[:file_cache_path]}/ppl-#{ppl_version}.tar.bz2 -C #{install_dir}
    cd #{install_dir}/ppl-#{ppl_version}
    ./configure --prefix=/usr/local/gcc --with-gmp=/usr/local/gcc
    make && make install && make clean
  EOL
end

# cloog
remote_file "#{Chef::Config[:file_cache_path]}/cloog-#{cloog_version}.tar.gz" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/cloog-#{cloog_version}.tar.gz"
  source "#{cloog_source_url}"
end

bash 'install_cloog' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xzf #{Chef::Config[:file_cache_path]}/cloog-#{cloog_version}.tar.gz -C #{install_dir}
    cd #{install_dir}/cloog-#{cloog_version}
    ./configure --prefix=/usr/local/gcc --with-gmp-prefix=/usr/local/gcc
    make && make install && make clean
  EOL
end

# gcc
remote_file "#{Chef::Config[:file_cache_path]}/gcc-#{gcc_version}.tar.bz2" do
  not_if "test -e #{Chef::Config[:file_cache_path]}/gcc-#{gcc_version}.tar.bz2"
  source "#{gcc_source_url}/gcc-#{gcc_version}/gcc-#{gcc_version}.tar.bz2"
end

bash 'install_gcc' do
  not_if "test -e /usr/local/gcc/bin/gcc#{gcc_version}"
  user 'root'

  code <<-EOL
    cd #{install_dir}
    tar xf #{Chef::Config[:file_cache_path]}/gcc-#{gcc_version}.tar.bz2 -C #{install_dir}
    mkdir #{install_dir}/gcc-#{gcc_version}/objdir
    cd #{install_dir}/gcc-#{gcc_version}/objdir
	export LD_LIBRARY_PATH=/usr/local/gcc/lib
    ../configure --prefix=/usr/local/gcc --with-gmp=/usr/local/gcc --with-mpfr=/usr/local/gcc --with-mpc=/usr/local/gcc --with-ppl=/usr/local/gcc --with-cloog=/usr/local/gcc --program-suffix=#{gcc_version} --disable-bootstrap
    make && make install && make clean
	alias gcc='/usr/local/gcc/bin/gcc#{gcc_version}'
	alias g++='/usr/local/gcc/bin/g++#{gcc_version}'
    cd ~/
  EOL
end

