# # encoding: utf-8

# Inspec test for recipe devpio::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

raise if os.windows?

describe user('root') do
  it { should exist }
end

control 'devpi-server-1' do
  impact 1.0

  title 'Devpi server user and group schema'
  describe user('devpi') do
    it { should exist }
  end

  describe group('devpi') do
    it { should exist }
  end
end

control 'devpi-server-2' do
  impact 1.0
  title 'Devpi files/dir ownership'

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
end

control 'devpi-server-3' do
  impact 1.0
  title 'Devpi files/dir access'

  describe directory('/home/devpi/bin') do
    it { should be_readable.by_user('devpi') }
    it { should be_executable.by_user('devpi') }
  end

  describe file('/home/devpi/bin/devpi-server') do
    it { should be_readable.by_user('devpi') }
    it { should be_executable.by_user('devpi') }
  end
end

control 'devpi-service-1' do
  impact 1.0
  title 'Devpi service must run'

  describe service('devpi') do
    it { should be_enabled }
    it { should be_running }
  end

  describe processes('devpi-server') do
    its('list.length') { should eq 1 }
    its('users') { should eq ['devpi'] }
  end
end

control 'devpi-service-2' do
  impact 1.0
  title 'Devpi must listen on the required port'

  describe port(3141) do
    it { should be_listening }
  end
end
