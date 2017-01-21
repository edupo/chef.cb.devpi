# # encoding: utf-8

# Inspec test for recipe devpio::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

raise if os.windows?

# System
describe user('root') do
  it { should exist }
end

describe user('devpi') do
  it { should exist }
end

describe group('devpi') do
  it { should exist }
end

# Files and folders

describe directory('/home/devpi') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

describe directory('/var/devpi') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

describe directory('/home/devpi/bin') do
  it { should be_readable.by_user('devpi') }
  it { should be_executable.by_user('devpi') }
end

describe file('/home/devpi/bin/devpi-server') do
  it { should be_readable.by_user('devpi') }
  it { should be_executable.by_user('devpi') }
end

describe file('/var/devpi/.nodeinfo') do
  it { should be_owned_by 'devpi' }
  it { should be_grouped_into 'devpi' }
end

# Processes

describe processes('devpi-server') do
  its('list.length') { should eq 1 }
  its('users') { should eq ['devpi'] }
end

# Network

describe port(3141) do
  it { should be_listening }
end
