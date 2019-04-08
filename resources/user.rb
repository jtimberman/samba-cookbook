property :password, String
property :comment, String
property :home, String, default: lazy { ::File.join('/home/', name) }
property :shell, String, default: '/bin/bash'
property :manage_home, [true, false], default: true

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
    password generate_system_password
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

action_class.class_eval do
  require 'mixlib/shellout'
  def generate_system_password
    system_password = \
      new_resource.password.crypt('$6$' + SecureRandom.random_number(36**8).to_s(36))
    Chef::Log.debug "SC: generated system password: #{system_password}"
    system_password
  end
end
