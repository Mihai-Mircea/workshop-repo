#
# Cookbook:: tomcat
# Recipe:: server

#
# Copyright:: 2017, Student Name, All Rights Reserved.

package 'java-1.7.0-openjdk-devel' do
  action :install
end

group 'tomcat' do
  action :create
end

user 'tomcat' do
  group 'tomcat'
  action :create
end

remote_file '/tmp/apache-tomcat-8.5.23.tar.gz' do
  source 'http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz'
  action :create
end

remote_file '/tmp/sample.war' do
  source 'https://github.com/johnfitzpatrick/certification-workshops/raw/master/Tomcat/sample.war'
  action :create
end

directory '/opt/tomcat' do
  action :create
end

execute 'extract tomcat binary' do
  command 'tar xvf /tmp/apache-tomcat-8.5.23.tar.gz -C /opt/tomcat --strip-components=1'
  action :nothing
  subscribes :run, 'directory[/opt/tomcat]', :immediately
end

#$ sudo chgrp -R tomcat /opt/tomcat/conf
#$ sudo chmod g+rwx /opt/tomcat/conf
#$ sudo chmod g+r /opt/tomcat/conf/*
#$ sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/

execute 'chgrp -R tomcat /opt/tomcat/conf' do
  action :nothing
  subscribes :run, 'execute[extract tomcat binary]', :immediately
end

execute 'chmod g+rwx /opt/tomcat/conf' do
  action :nothing
  subscribes :run, 'execute[extract tomcat binary]', :immediately
end

execute 'chmod g+r /opt/tomcat/conf/*' do
  action :nothing
  subscribes :run, 'execute[extract tomcat binary]', :immediately
end

execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/' do
  action :nothing
  subscribes :run, 'execute[extract tomcat binary]', :immediately
end

cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  action :create
end

#service 'tomcat' do
#  action [:start,:enable]
#end 

template '/opt/tomcat/conf/server.xml' do
  source 'server.xml.erb'
  variables({
    port: node['tomcat']['port']
  })
end

execute 'start Tomcat' do
  command '/opt/tomcat/bin/catalina.sh start'
end


