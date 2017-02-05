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

actions :create, :remove
default_action :create

# :user that executes the server
# :group of the :user
# :home_dir where the binaries and virtual environment are created
# :data_dir working directory for the server
# :host address from where server will listen (0.0.0.0 is all)
# :port where server listens
# :version of the server package. nil means latests.
# :package name for the server

property :user, String, default: 'devpi'
property :group, String, default: 'devpi'

property :home_dir, String
property :data_dir, String, default: '/var/devpi'

property :host, String, default: 'localhost'
property :port, Integer, default: 3141, callbacks: {
  'should be a valid non-system port' => lambda do |p|
    p > 1024 && p < 65_535
  end
}

property :version, String
property :package, String, default: 'devpi-server'
