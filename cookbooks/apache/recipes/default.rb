#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.

#include_recipe 'java::default'

package('httpd') do
  action :install
end

package('java-1.8.0-openjdk.x86_64') do
  action :install
end

package('iproute') do
  action :install
end

template('/var/www/html/index.html') do
  action :create
  source 'index.html.erb'
  variables ({
    author: node['page']['author'],
    ip: node['ipaddress'],
    name: node['hostname']
  })
end

template('/etc/httpd/conf/httpd.conf') do
  action :create
  source 'httpd.conf.erb'
  variables ({
    port: node['apache']['port']
  })
end

service('httpd') do
  action [:enable, :start]
end


