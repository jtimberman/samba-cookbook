name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache 2.0'
description      'Installs/Configures samba'
version          '1.0.1'

%w( debian ubuntu centos fedora redhat scientific amazon oracle ).each do |os|
  supports os
end

source_url 'https://github.com/sous-chefs/samba'
issues_url 'https://github.com/sous-chefs/samba/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'compat_resource', '>= 12.16.3'
