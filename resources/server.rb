#
# Cookbook:: devpio
# Resource:: server
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

property :user, String, default: 'devpi'
property :group, String, default: 'devpi'

property :home_dir, String, default: nil 
property :data_dir, String, default: '/var/devpi'

property :host, String, default: 'localhost'
property :port, Fixnum, default: 3141, callbacks: {
  'should be a valid non-system port' => lambda {
    |p| p > 1024 && p < 65535
  }
}

property :version, String, default: nil
property :package, String, default: 'devpi-server'

load_current_value do
end

action :create do
  home_dir = "/home/#{user}" if home_dir.nil?

  # Making sure python is installed.
  include_recipe 'poise-python'
  
  python_runtime '3'

  log "The home is set to '${home_dir}'"

  declare_resource(:user, user) do
    gid group
    home home_dir 
    system true
  end

  python_virtualenv home_dir

  python_package package do
    version new_resource.version unless \
      new_resource.version.nil?
  end

  directory home_dir do
    owner user 
    group group 
    recursive true
  end

  directory data_dir do
    owner user 
    group group 
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
        name:     package,
        user:     user,
        group:    group,
        home_dir: home_dir,
        data_dir: data_dir,
        host:     host,
        port:     port 
      )
    end

  else

    template 'etc/init.d/devpi' do
      source 'devpi.init.erb'
      mode '0775'
      notifies :restart, 'service[devpi]', :delayed
      variables(
        name:     package,
        user:     user,
        group:    group,
        home_dir: home_dir,
        data_dir: data_dir,
        host:     host,
        port:     port 
      )
    end

  end

  service 'devpi' do
    supports status: true, restart: true, start: true, stop: true
    action :enable
  end
end
