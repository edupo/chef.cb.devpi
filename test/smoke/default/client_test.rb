# # encoding: utf-8

# Inspec test for recipe devpio::client

raise if os.windows?

describe user('root') do
  it { should exist }
end

control 'devpi-client-1' do
  impact 1.0
  title 'Devpi client properly installed'

  describe command('devpi') do
    it { should exist }
  end

  describe command('devpi --version') do
    its('stdout') { should match(/devpi-client/) }
  end
end
