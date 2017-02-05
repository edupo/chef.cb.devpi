#
# Cookbook:: devpio
# HWPR:: user
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

class Chef
  class Resource
    #
    # The HWRP DevpiUser manages exactly that. A devpi user.
    #
    class DevpiUser < LWRPBase
      provides :devpi_user

      # User data is sensitive by default
      def initialize(name, run_context = nil)
        super
        @sensitive = true
      end

      resource_name :devpi_user

      # Actions
      actions :create, :remove
      default_action :create

      # Attributes
      attribute :password,
                kind_of: String,
                required: true
      attribute :server_url,
                kind_of: String

      attr_writer :exists

      #
      # Determines if user exist in the server already. This value is set
      # by the provider when the current resource is loaded.
      #
      # @return [Boolean]
      #
      def exists?
        !@exists.nil? && @exists
      end
    end
  end
end

class Chef
  class Provider
    #
    # The HWRP DevpiUser manages exactly that. A devpi user.
    #
    class DevpiUser < LWRPBase
      provides :devpi_user

      use_inline_resources

      Cmd = Mixlib::ShellOut

      #
      # This provider supports why-run node
      #
      def whyrun_supported?
        true
      end

      def load_current_resource
        @current_resource ||= Resource::DevpiUser.new(new_resource.name)
        fetch_server_url
        @current_resource.name = new_resource.name
        @current_resource.password = new_resource.password
        @current_resource.exists = user_exist
        @current_resource
      end

      def fetch_server_url
        if new_resource.server_url.nil?
          @current_resource.server_url = \
            "http://localhost:#{node['devpi']['server']['port']}"
        else
          @current_resource.server_url = new_resource.server_url
        end
      end

      action :create do
        if current_resource.exists?
          Chef::Log.info("#{new_resource} exists - skipping")
        else
          converge_by("Create #{new_resource}") do
            create
          end
        end
      end

      action :remove do
        if !current_resource.exists?
          Chef::Log.info("#{new_resource} does not exist - skipping")
        else
          converge_by("Remove #{new_resource}") do
            remove
          end
        end
      end

      #
      # Configure devpi client to Use the server configured for this user
      #
      def use
        Cmd.new("devpi use '#{@current_resource.server_url}'").run_command
      end

      #
      # Creates devpi user through root devpi user
      #
      def create
        use
        login('root', '')
        Cmd.new("devpi user -c '#{@current_resource.name}' \
                 password='#{@current_resource.password}'").run_command
        logoff
      end

      #
      # Removes devpi user through root user
      #
      def remove
        use
        login('root', '')
        Cmd.new("devpi user -y --delete '#{@current_resource.name}'")
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
      def user_exist
        find = Cmd.new("devpi user -l | grep #{@current_resource.name}")
        find.run_command
        find.stdout =~ /^#{@current_resource.name}$/
      end
    end
  end
end
