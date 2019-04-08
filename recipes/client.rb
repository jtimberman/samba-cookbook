case node['platform_family']
when 'rhel', 'fedora', 'suse', 'amazon'
  package 'samba-client'
else
  package 'smbclient'
end
