#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.

package('iproute') do
  action :install
end

package('haproxy') do
  action :install
end

template('/etc/haproxy/haproxy.cfg') do
  source 'haproxy.cfg.erb'
  variables({
    port: node['haproxy']['port'],
    server_ip: '10.1.1.5',
    apache_port: '8080'
  })
end

service('haproxy') do
  action [:enable,:start]
end

