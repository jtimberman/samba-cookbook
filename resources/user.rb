#
# Cookbook:: samba
# Resource:: user
#
# Copyright:: 2010-2017, Chef Software, Inc <legalchef.io>
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

unified_mode true

property :password,
        String,
        sensitive: true,
        description: 'User password for samba and the system'

property :comment,
        String,
        description: 'One (or more) comments about the user'

property :home,
        String,
        default: lazy { ::File.join('/home/', name) },
        description: 'Users home'

property :shell,
        String,
        default: '/bin/bash',
        description: 'User shell to set, e.g. /bin/sh, /sbin/nologin'

property :manage_home,
        [true, false],
        default: true,
        description: 'Whether to manage the users home directory location'

def load_current_value
  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)

  Chef::Log.debug("Checking for smbuser #{new_resource.name}")
  u = Mixlib::ShellOut.new("pdbedit -Lv -u #{new_resource.name}")
  u.run_command
  exists = u.stdout.include?(new_resource.name)
  disabled = u.stdout.include?('Account Flags.*[D')
  @smbuser.exists(exists)
  @smbuser.disabled(disabled)
end

action :create do
  user new_resource.name do
    password new_resource.password
    comment new_resource.comment
    home new_resource.home
    shell new_resource.shell
    manage_home new_resource.manage_home
    notifies :run,
             "execute[Create samba user #{new_resource.name}]",
             :immediately
  end

  group new_resource.name do
    members new_resource.name
    action :create
  end

  directory new_resource.home do
    group new_resource.name
    user new_resource.name
  end

  passwd = new_resource.password
  execute "Create samba user #{new_resource.name}" do
    command "echo '#{passwd}\n#{passwd}' | smbpasswd -s -a #{new_resource.name}"
    sensitive true
    action :nothing
  end
end

action :enable do
  execute "Enable #{new_resource.name}" do
    command "smbpasswd -e #{new_resource.name}"
    only_if { @smbuser.disabled }
  end
end

action :delete do
  if @smbuser.exists
    execute "Delete #{new_resource.name}" do
      command "smbpasswd -x #{new_resource.name}"
    end
  end
end
