#
# Cookbook:: devpio
# HWPR:: devpi client helper functions
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

# Helper functions for managing server through a devpi client.
module DevpiClientHelpers
  # Alias for ShellOut
  Cmd = Mixlib::ShellOut

  #
  # Configure devpi client to Use the server configured for this user
  #
  def use
    Cmd.new("devpi use '#{new_resource.server_url}'").run_command
  end

  #
  # Creates devpi user through root devpi user
  #
  def create
    use
    login('root', '')
    Cmd.new("devpi user -c '#{new_resource.name}' \
             password='#{new_resource.password}'").run_command
    logoff
  end

  #
  # Removes devpi user through root user
  #
  def remove
    use
    login('root', '')
    Cmd.new("devpi user -y --delete '#{new_resource.name}'")
    logoff
  end

  #
  # Devpi login as some user
  #
  def login(name, password)
    Cmd.new("devpi login '#{name}' --password '#{password}'").run_command
  end

  #
  # Devpi client logoff
  #
  def logoff
    Cmd.new('devpi logoff').run_command
  end

  #
  # Discover if user exists on the server
  #
  def user_exists?
    find = Cmd.new("devpi user -l | grep #{new_resource.name}")
    find.run_command
    find.stdout =~ /^#{new_resource.name}$/
  end
end
