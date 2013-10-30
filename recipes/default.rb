#
# Cookbook Name:: mongrel2
# Recipe:: default
#
# Author:: Thomas Rampelberg (<thomas@saunter.org>)
#
# Copyright 2011, Thomas Rampelberg
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

include_recipe "build-essential"

# include_recipe "zeromq"
package "libzmq-dev"

include_recipe "daemontools"

user "m2" do
  comment "Mongrel2 Administrator"
  system true
  shell "/bin/false"
end

%w{ sqlite3 libsqlite3-dev }.each do |pkg|
  package pkg do
    action :upgrade
  end
end

m2_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "mongrel2-#{node[:mongrel2][:src_version]}.tar.gz")
basedir = "/opt/mongrel2-#{node[:mongrel2][:src_version]}"

%w{ etc run logs tmp www }.each do |dir|
  directory "#{basedir}/#{dir}" do
    recursive true
    owner "m2"
    group "m2"
    mode "0755"
  end
end

template "#{basedir}/etc/mongrel2.conf" do
  source "m2.conf.erb"
end

cookbook_file "#{basedir}/www/index.html" do
  source "index.html"
  mode "0755"
end

remote_file m2_tar_gz do
  source node[:mongrel2][:src_mirror]
  checksum node[:mongrel2][:checksum]
end

bash "install mongrel2 #{node[:mongrel2][:src_version]}" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf #{m2_tar_gz}
    cd mongrel2-#{node[:mongrel2][:src_version]} && LD_LIBRARY_PATH=/opt/zeromq-#{node[:zeromq][:src_version]}/lib:$LD_LIBRARY_PATH make clean all && PREFIX=#{basedir} make install
  EOH
  not_if { ::FileTest.exists?("#{basedir}/bin") }
end

bash "generate config <mongrel2-#{node[:mongrel2][:src_version]}" do
  cwd node[:mongrel2][:chroot]
  code <<-EOH
    LD_LIBRARY_PATH=/opt/zeromq-#{node[:zeromq][:src_version]}/lib bin/m2sh load --db etc/mongrel2.sqlite --config etc/mongrel2.conf
  EOH
end

directory "/etc/sv/mongrel2" do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

daemontools_service "mongrel2" do
  directory "/etc/sv/mongrel2"
  template "mongrel2"
  action [:enable,:start]
  log true
end
