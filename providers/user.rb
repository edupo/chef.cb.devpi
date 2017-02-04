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

action :create do
  user = new_resource

  execute 'devpi use' do
    command "devpi use '#{user.server_url}'"
  end
  
  devpio_user 'root' do
    password ''
    action :login
  end

  execute 'devpi user create' do
    command "devpi user -c '#{user.name}' password='#{user.password}'"
    not_if "devpi user -l | grep #{user.name}"
  end 

  devpio_user 'root' do
    password ''
    action :logoff
  end
end

action :remove do
end

action :login do
  user = new_resource
  execute 'devpi use' do
    command "devpi use '#{user.server_url}'"
  end
  execute 'devpi login' do
    command "devpi login '#{user.name}' --password '#{user.password}'"
  end
end

action :logoff do
  user = new_resource
  execute 'devpi use' do
    command "devpi use '#{user.server_url}'"
  end
  execute 'devpi logoff' do
    command 'devpi logoff'
  end
end
