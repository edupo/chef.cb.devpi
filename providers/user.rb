#
# Cookbook:: devpio
# Provider:: user
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

Cmd = Mixlib::ShellOut

action :create do
  user = new_resource

  devpi_use(user.server_url)

  exist = devpi_user_exist?(user.name)

  create(user.server_url, user.name, user.password) unless exist

  new_resource.updated_by_last_action(!exist)
end

action :remove do
  user = new_resource

  devpi_use(user.server_url)

  exist = devpi_user_exist?(user.server_url, user.name)

  remove(user.server_url, user.name) if exist

  new_resource.updated_by_last_action(exist)
end

def devpi_use(url)
  Cmd.new("devpi use '#{url}'").run_command
end

def create(url, name, password)
  devpi_use(url)
  login('root', '')
  Cmd.new("devpi user -c '#{name}' password='#{password}'").run_command
  logoff
end

def remove(url, name)
  devpi_use(url)
  login(url, 'root', '')
  Cmd.new("devpi user -y --delete '#{name}'")
  logoff
end

def login(name, password)
  Cmd.new("devpi login '#{name}' --password '#{password}'").run_command
end

def logoff
  Cmd.new('devpi logoff').run_command
end

def devpi_user_exist?(name)
  find = Cmd.new("devpi user -l | grep #{name}")
  find.run_command
  find.stdout =~ /^#{name}$/
end
