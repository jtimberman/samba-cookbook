property :share_name, String, name_property: true
property :comment, String
property :path, String, required: false
property :valid_users, String, default: ''
property :force_group, String, default: ''
property :browseable, String, default: 'yes', equal_to: %w(yes no)
property :guest_ok, String, default: 'no', equal_to: %w(yes no)
property :printable, String, default: 'no', equal_to: %w(yes no)
property :write_list, Array, required: false
property :create_mask, String, default: '0744', required: false
property :directory_mask, String, default: '0755', required: false
property :read_only, String, default: 'no', equal_to: %w(yes no)
property :create_directory, [TrueClass, FalseClass], default: true
property :options, Hash, default: {}
property :config_file, String, default: lazy {
  if node['platform_family'] == 'smartos'
    '/opt/local/etc/samba/smb.conf'
  else
    '/etc/samba/smb.conf'
  end
}

action :add do
  # We need to force both the server template and the
  # share templates into the root context to find each other
  with_run_context :root do
    edit_resource(:template, new_resource.config_file) do |new_resource|
      cookbook 'samba'
      variables[:shares] ||= {}
      variables[:shares][new_resource.share_name] ||= {}
      variables[:shares][new_resource.share_name]['comment'] = new_resource.comment
      variables[:shares][new_resource.share_name]['path'] = new_resource.path
      variables[:shares][new_resource.share_name]['guest ok'] = new_resource.guest_ok
      variables[:shares][new_resource.share_name]['printable'] = new_resource.printable
      variables[:shares][new_resource.share_name]['write list'] = new_resource.write_list
      variables[:shares][new_resource.share_name]['create mask'] = new_resource.create_mask
      variables[:shares][new_resource.share_name]['directory mask'] = new_resource.directory_mask
      variables[:shares][new_resource.share_name]['read only'] = new_resource.read_only
      variables[:shares][new_resource.share_name]['valid users'] = new_resource.valid_users
      variables[:shares][new_resource.share_name]['force group'] = new_resource.force_group
      variables[:shares][new_resource.share_name]['browseable'] = new_resource.browseable
      new_resource.options.each do |key, value|
        variables[:shares][new_resource.share_name][key] = value
      end

      action :nothing
      delayed_action :create
    end
  end

  if new_resource.create_directory
    directory new_resource.path do
      recursive true
    end
  end
end
