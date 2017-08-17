#
# Cookbook:: devpio
# Resource:: user
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

default_action :create

# :password of the user
# :server_url where the user exists

property :password, String
property :server_url, String,
         default: "http://localhost:#{node['devpi']['server']['port']}"

extend DevpiClientHelpers

action_class do
  # Mixin helpers
  include DevpiClientHelpers

  # If not defined by default
  use_inline_resources

  # Whyrun supported
  def whyrun_supported?
    true
  end
end

action :create do
  if user_exists?
    Chef::Log.info("#{new_resource} exists - skipping")
  else
    converge_by("Create #{new_resource}") do
      create
    end
  end
end

action :remove do
  if user_exists?
    converge_by("Remove #{new_resource}") do
      remove
    end
  else
    Chef::Log.info("#{new_resource} does not exist - skipping")
  end
end
