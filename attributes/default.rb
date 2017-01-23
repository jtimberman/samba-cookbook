#
# Cookbook:: samba
# Attributes:: default
#
# Copyright:: 2010-2017, Chef Software, Inc.
# Copyright:: 2014-2017, Joshua Timberman <cookbooks@housepub.org>
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

default['samba']['workgroup']            = 'SAMBA'
default['samba']['interfaces']           = 'lo 127.0.0.1'
default['samba']['hosts_allow']          = '127.0.0.0/8'
default['samba']['bind_interfaces_only'] = 'no'
default['samba']['server_string']        = 'Samba Server'
default['samba']['load_printers']        = 'no'
default['samba']['passdb_backend']       = 'tdbsam'
default['samba']['enable_users_search']  = true
default['samba']['dns_proxy']            = 'no'
default['samba']['security']             = 'user'
default['samba']['map_to_guest']         = 'Bad User'
default['samba']['socket_options']       = 'TCP_NODELAY'
default['samba']['shares_data_bag']      = 'samba'
default['samba']['users_data_bag']       = 'users'
default['samba']['options']              = {}

case node['platform_family']
when 'smartos'
  default['samba']['client_package'] = 'smbclient'
  default['samba']['server_package'] = 'samba'
  default['samba']['services']       = %w(smbd nmbd)
  set['samba']['config']             = '/opt/local/etc/samba/smb.conf'
  set['samba']['log_dir']            = '/var/log/samba/log.%m'
when 'arch'
  default['samba']['client_package'] = 'smbclient'
  default['samba']['server_package'] = 'samba'
  default['samba']['services']       = ['samba']
  default['samba']['config']         = '/etc/samba/smb.conf'
  default['samba']['log_dir']        = '/var/log/samba/log.%m'
when 'debian'
  default['samba']['client_package'] = 'smbclient'
  default['samba']['server_package'] = 'samba'
  default['samba']['services']       = if platform?('ubuntu') || platform?('linuxmint')
                                         %w(smbd nmbd)
                                       else
                                         ['samba']
                                       end
  default['samba']['config']         = '/etc/samba/smb.conf'
  default['samba']['log_dir']        = '/var/log/samba/%m.log'
when 'rhel', 'fedora'
  default['samba']['client_package'] = 'samba-client'
  default['samba']['server_package'] = 'samba'
  default['samba']['services']       = %w(smb nmb)
  default['samba']['config']         = '/etc/samba/smb.conf'
  default['samba']['log_dir']        = '/var/log/samba/log.%m'
else
  default['samba']['client_package'] = 'smbclient'
  default['samba']['server_package'] = 'samba'
  default['samba']['services']       = %w(smbd nmbd)
  default['samba']['config']         = '/etc/samba/smb.conf'
  default['samba']['log_dir']        = '/var/log/samba/%m.log'
end
