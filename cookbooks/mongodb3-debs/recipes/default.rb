#
# Author:: Jose Luis Illana Ruiz (joseluisillana@gmail.com)
# Cookbook Name:: mongodb-3.0
# Recipe:: MongoDB 3.0 on Ubuntu Trusty (stable)
#
# 2015 - Jose Luis Illana Ruiz
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

include_recipe "mongodb3-debs::repo"

package "mongodb-3.0"

service "mongodb" do
  action [ :enable, :start ]
end

template "/etc/mongodb.conf" do
  source "mongodb.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "mongodb")
end
