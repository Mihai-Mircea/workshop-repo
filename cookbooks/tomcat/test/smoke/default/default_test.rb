# # encoding: utf-8

# Inspec test for recipe tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(8081), :skip do
  it { should_not be_listening }
end

describe file('/opt/tomcat/conf/server.xml') do
  it { should exist }
  its('group') { should eq 'tomcat' }
end

describe user('kitchen') do
  it { should exist }
end

describe http('http://localhost:8080') do
  its('status') { should cmp 200 }
end

