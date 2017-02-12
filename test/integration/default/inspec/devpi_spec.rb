# encoding: utf-8
# Inspec test for recipe devpio::server

# Tests only supported in Linux
raise if os.windows?

# Client

describe command('devpi') do
  it { should exist }
end

describe command('devpi --version') do
  its('stdout') { should match(/devpi-client/) }
end

# Server

## Devpi user
describe user('devpi') do
  it { should exist }
end

describe group('devpi') do
  it { should exist }
end

## Devpi-server folders

describe directory('/home/devpi') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

describe directory('/var/devpi') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

describe file('/var/devpi/.nodeinfo') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

## Devpi-server binaries access

describe directory('/home/devpi/bin') do
  it { should be_readable.by_user('devpi') }
  it { should be_executable.by_user('devpi') }
end

describe file('/home/devpi/bin/devpi-server') do
  it { should be_readable.by_user('devpi') }
  it { should be_executable.by_user('devpi') }
end

## Devpi service

describe service('devpi') do
  it { should be_enabled }
  it { should be_running }
end

describe processes('devpi-server') do
  its('list.length') { should eq 1 }
  its('users') { should eq ['devpi'] }
end

# Skipped for the moment -> 'https://github.com/chef/inspec/issues/1394'
# describe port(3141) do
#   it { should be_listening }
# end
