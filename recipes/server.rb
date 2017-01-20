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

server_home    = node['devpi']['server']['home_dir']
server_data    = node['devpi']['server']['data_dir']
server_user    = node['devpi']['server']['user']
server_group   = node['devpi']['server']['group']

server_name    = node['devpi']['server']['name']
server_version = node['devpi']['server']['version']

group server_group do
  system true
end

user server_user do
  gid server_group
  home server_home
  shell '/bin/false'
  system true
end

directory server_home do
  owner server_user
  group server_group
end

directory server_data do
  owner server_user
  group server_group
  mode 0o770
  recursive true
end

python_virtualenv server_home

python_package server_name do
  version server_version unless server_version.nil?
end
