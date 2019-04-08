property :server_string, String, name_property: true
property :workgroup, String, default: 'SAMBA'
property :interfaces, String, default: 'lo 127.0.0.1'
property :hosts_allow, String, default: '127.0.0.0/8'
property :bind_interfaces_only, String, default: 'no', equal_to: %w(yes no)
property :load_printers, String, default: 'no', equal_to: %w(yes no)
property :passdb_backend, String, default: 'tdbsam', equal_to: %w(ldapsam tdbsam smbpasswd)
property :dns_proxy, String, default: 'no', equal_to: %w(yes no)
property :security, String, default: 'user', equal_to: %w(user domain ADS share server)
property :map_to_guest, String, default: 'Bad User'
property :realm, String, default: ''
property :password_server, String, default: '*'
property :encrypt_passwords, String, default: 'yes', equal_to: %w(yes no)
property :kerberos_method, String, default: 'secrets only', equal_to: ['secrets only', 'system keytab', 'dedicated keytab', 'secrets and keytab']
property :log_level, String, default: '0'
property :winbind_separator, String, default: '\\'
property :idmap_config, String
property :socket_options, String, default: '`TCP_NODELAY`'
property :log_dir, String, default: lazy { Chef::Samba.log_dir }
property :max_log_size, [String, Integer], default: '5000' # 5M
property :options, [Hash, nil], default: nil
property :enable_users_search, [TrueClass, FalseClass], default: true
property :shares, [Hash, nil], default: nil
property :config_file, String, default: '/etc/samba/smb.conf'
property :samba_services, Array, default: lazy {
  case node['platform_family']
  when 'rhel', 'fedora', 'amazon', 'suse'
    %w(smb nmb)
  else
    %w(smbd nmbd)
  end
}

action :create do
  package 'samba'

  # We need to force both the server template and the
  # share templates into the root context to find each other
  with_run_context :root do
    template new_resource.config_file do
      source 'smb.conf.erb'
      owner 'root'
      group 'root'
      mode '0644'
      cookbook 'samba'
      variables(
        idmap_config: new_resource.idmap_config,
        winbind_separator: new_resource.winbind_separator,
        kerberos_method: new_resource.kerberos_method,
        encrypt_passwords: new_resource.encrypt_passwords,
        password_server: new_resource.password_server,
        realm: new_resource.realm,
        workgroup: new_resource.workgroup,
        server_string: new_resource.server_string,
        security: new_resource.security,
        map_to_guest: new_resource.map_to_guest,
        interfaces: new_resource.interfaces,
        hosts_allow: new_resource.hosts_allow,
        load_printers: new_resource.load_printers,
        passdb_backend: new_resource.passdb_backend,
        dns_proxy: new_resource.dns_proxy,
        samba_options: new_resource.options,
        log_level: new_resource.log_level,
        max_log_size: new_resource.max_log_size,
        bind_interfaces_only: new_resource.bind_interfaces_only
      )
      new_resource.samba_services.each do |samba_service|
        notifies :restart, "service[#{samba_service}]", :delayed
        notifies :enable, "service[#{samba_service}]", :delayed
      end

      action :nothing
      delayed_action :create
    end

    new_resource.samba_services.each do |s|
      service s do
        supports restart: true, reload: true
        action [:nothing]
      end
    end
  end
end

action_class do
  include Chef::Samba
end
