default['mysql']['source_url'] = "http://cdn.mysql.com/Downloads/MySQL-5.6/"
default['mysql']['version'] = '5.6'

default['mysql']['tar_file'] = 'MySQL-5.6.14-1.linux_glibc2.5.i386.rpm-bundle.tar'

default['mysql']['character_set_server']     = 'utf8'

default['mysql']['install_rpms'] = [
  {
    :rpm_file => 'MySQL-shared-compat-5.6.14-1.linux_glibc2.5.i386.rpm',
    :package_name => 'MySQL-shared-compat'
  },
  {
    :rpm_file => 'MySQL-client-5.6.14-1.linux_glibc2.5.i386.rpm',
    :package_name => 'MySQL-client'
  },
  {
    :rpm_file => 'MySQL-devel-5.6.14-1.linux_glibc2.5.i386.rpm',
    :package_name => 'MySQL-devel'
  },
  {
    :rpm_file => 'MySQL-shared-5.6.14-1.linux_glibc2.5.i386.rpm',
    :package_name => 'MySQL-shared'
  },
  {
    :rpm_file => 'MySQL-server-5.6.14-1.linux_glibc2.5.i386.rpm',
    :package_name => 'MySQL-server'
  },
]
