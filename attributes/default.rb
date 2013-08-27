#
# Cookbook Name:: jboss
# Attributes:: default
#
# Copyright 2013, Standing Cloud
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
#

# default attributes for all platforms
default['jboss']['install_path'] = "/usr/local"
default['jboss']['jboss_home'] = "/opt/jboss"

default['jboss']['version'] = '5.1.0.GA'
default['jboss']['archive'] = "jboss-#{node['jboss']['version']}-jdk6.zip"
default['jboss']['extract_dir'] = "jboss-#{node['jboss']['version']}"
default['jboss']['checksum'] = 'bee49ee4dd833e6cfa6c87628065cc38939be7783f034e300e9d94028d31c573'
default['jboss']['url'] = "http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-#{node['jboss']['version']}/#{node['jboss']['archive']}"

default['jboss']['extract_path'] = "#{node['jboss']['install_path']}/#{node['jboss']['extract_dir']}"
