#
# Cookbook:: devpio
# Attribute Set:: default
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

# Server
default['devpi']['server']['host']     = 'localhost'
default['devpi']['server']['port']     = 3141

default['devpi']['server']['data_dir'] = '/var/devpi'

# Root password is defined as an attribute because is needed for every
# operation on the server.
# TODO: Store root user in some other way more secured (encrypted data bag?)
default['devpi']['root_user']['password'] = 'password'
