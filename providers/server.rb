#
# Cookbook:: devpio
# Provider:: server
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

use_inline_resources

def whyrun_supported?
  true
end

# rubocop:disable Metrics/BlockLength

action :remove do
  service 'devpi' do
    action :stop, :disable
  end

  python_package new_resource.package do
    action :remove
  end

  python_virtualenv new_resource.package do
    action :delete
  end
end

action :create do
  new_resource.home_dir = "/home/#{new_resource.user}" if \
    new_resource.home_dir.nil?

  include_recipe 'poise-python'
  python_runtime '3'

  group new_resource.group do
    system true
  end

  user new_resource.user do
    gid new_resource.group
    home new_resource.home_dir
    system true
  end

  python_virtualenv new_resource.home_dir

  python_package new_resource.package do
    version new_resource.version unless \
      new_resource.version.nil?
  end

  directory new_resource.home_dir do
    owner new_resource.user
    group new_resource.user
    recursive true
  end

  directory new_resource.data_dir do
    owner new_resource.user
    group new_resource.group
    mode '0770'
    recursive true
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
        name:     new_resource.package,
        user:     new_resource.user,
        group:    new_resource.group,
        home_dir: new_resource.home_dir,
        data_dir: new_resource.data_dir,
        host:     new_resource.host,
        port:     new_resource.port
      )
    end

  else

    template 'etc/init.d/devpi' do
      source 'devpi.init.erb'
      mode '0775'
      notifies :restart, 'service[devpi]', :delayed
      variables(
        name:     new_resource.package,
        user:     new_resource.user,
        group:    new_resource.group,
        home_dir: new_resource.home_dir,
        data_dir: new_resource.data_dir,
        host:     new_resource.host,
        port:     new_resource.port
      )
    end

  end

  service 'devpi' do
    supports status: true, restart: true, start: true, stop: true
    action :enable
  end
end

# rubocop:enable Metrics/BlockLength
