#
# Cookbook:: users
# Recipe:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.

current_time = Time.now
if (current_time.hour >= 9) and (current_time.hour <= 18)
  ::File.new('/tmp/usersallowed', 'w+')
else
  if(::File.exist?('/tmp/usersallowed'))
    ::File.delete('/tmp/usersallowed')
  end
end

users = search(:users, '*:*')
groups = search(:groups, '*:*')

users.each do |my_user|
  user(my_user['id']) do
    action :create
    only_if { File.exist?('/tmp/usersallowed') }
    notifies :create, 'file[/tmp/timestamp]'
  end
end

users.each do |my_user|
  user(my_user['id']) do
    action :remove
    not_if { File.exist?('/tmp/usersallowed') }
    notifies :create, 'file[/tmp/timestamp]'
  end
end

groups.each do |my_group|
  group(my_group['id']) do
    members my_group['members']
    action :create
    only_if { File.exist?('/tmp/usersallowed') }
  end
end

file('/tmp/timestamp') do
  action :nothing
  content "#{current_time}"
end
