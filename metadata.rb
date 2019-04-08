name             'samba'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures samba'
version          '2.0.0'
source_url       'https://github.com/sous-chefs/samba'
issues_url       'https://github.com/sous-chefs/samba/issues'
chef_version     '>= 13.0' if respond_to?(:chef_version)

%w(debian ubuntu centos fedora redhat scientific amazon oracle).each do |os|
  supports os
end
