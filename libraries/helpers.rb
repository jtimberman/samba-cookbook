class Chef
  module Samba
    def self.log_dir
      case node['platform_family']
      when 'rhel', 'fedora', 'amazon', 'suse'
        '/var/log/samba/log.%m'
      else
        '/var/log/samba/%m.log'
      end
    end
  end
end
