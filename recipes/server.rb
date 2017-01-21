#
# Cookbook:: devpio
# Recipe:: server
#
# Copyright:: 2017, Eduardo Lezcano
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'poise-python'

group node['devpi']['server']['group'] do
  system true
end

user node['devpi']['server']['user'] do
  gid node['devpi']['server']['group']
  home node['devpi']['server']['home_dir']
  shell '/bin/false'
  system true
end

directory node['devpi']['server']['home_dir'] do
  owner node['devpi']['server']['user']
  group node['devpi']['server']['group']
end

directory node['devpi']['server']['data_dir'] do
  owner node['devpi']['server']['user']
  group node['devpi']['server']['group']
  mode '0770'
  recursive true
end

python_virtualenv node['devpi']['server']['home_dir']

python_package node['devpi']['server']['name'] do
  version node['devpi']['server']['version'] unless \
    node['devpi']['server']['version'].nil?
end

if node['init_package'] == 'systemd'

  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/devpi.service' do
    source 'devpi.service.erb'
    owner 'root'
    group 'root'
    mode '0775'
    action :create
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[devpi]', :delayed
    variables(
      :name => node['devpi']['server']['name'],
      :user => node['devpi']['server']['user'],
      :group => node['devpi']['server']['group'],
      :home_dir => node['devpi']['server']['home_dir'],
      :data_dir => node['devpi']['server']['data_dir'],
      :url => node['devpi']['server']['url'],
      :port => node['devpi']['server']['port'],
    )
  end

else

  template 'etc/init.d/devpi' do
    source 'devpi.init.erb'
    mode '0775'
    notifies :restart, 'service[devpi]', :delayed
    variables(
      :name => node['devpi']['server']['name'],
      :user => node['devpi']['server']['user'],
      :group => node['devpi']['server']['group'],
      :home_dir => node['devpi']['server']['home_dir'],
      :data_dir => node['devpi']['server']['data_dir'],
      :url => node['devpi']['server']['url'],
      :port => node['devpi']['server']['port'],
    )
  end

end

service 'devpi' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action :enable
end
