#
# Cookbook Name:: jboss
# Recipe:: default
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

src_filepath = "#{Chef::Config['file_cache_path']}/#{node['jboss']['archive']}"

#-------------------------------------------------------------------------------
#  Download JBoss
#-------------------------------------------------------------------------------
remote_file "#{src_filepath}" do
  source "#{node['jboss']['url']}"
  checksum "#{node['jboss']['checksum']}"
  owner 'root'
  group 'root'
  mode 00644
end

#-------------------------------------------------------------------------------
#  Install JBoss
#-------------------------------------------------------------------------------
bash 'extract_jboss_archive' do
  user "#{node['jboss']['user']}"
  group "#{node['jboss']['group']}"
  code "unzip -d #{node['jboss']['install_path']} #{src_filepath}"
  creates "#{node['jboss']['extract_path']}/bin/run.sh"
end

bash 'set_jboss_group_permissions' do
  code <<-EOH
    chmod -R g+w #{node['jboss']['extract_path']}
    find #{node['jboss']['extract_path']} -type d -exec chmod g+s {} \\;
  EOH
  not_if "#{node['jboss']['user']} == #{node['jboss']['group']} || test -g #{node['jboss']['extract_path']}"
end

bash 'create_jboss_symlink' do
  code "ln --symbolic --force #{node['jboss']['extract_path']} #{node['jboss']['jboss_home']}"
  not_if "test -e #{node['jboss']['jboss_home']}"
end

#-------------------------------------------------------------------------------
#  Setup JBOSS_HOME and PATH
#-------------------------------------------------------------------------------
ruby_block  "set-env-jboss-home" do
  block do
    ENV["JBOSS_HOME"] = node['jboss']['jboss_home']
  end
  not_if { ENV["JBOSS_HOME"] == node['jboss']['jboss_home'] }
end

directory "/etc/profile.d" do
  mode 00755
end

file "/etc/profile.d/jboss.sh" do
  content <<-EOH
    export JBOSS_HOME=#{node['jboss']['jboss_home']}
    export PATH=$PATH:$JBOSS_HOME/bin
  EOH
  mode 00755
end

#-------------------------------------------------------------------------------
#  Install runJBoss.sh wrapper script for run.sh
#-------------------------------------------------------------------------------
template "/usr/local/bin/runJBoss.sh" do
  source 'runJBoss.sh.erb'
  mode 00755
end
