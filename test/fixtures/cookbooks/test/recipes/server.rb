apt_update 'update' if platform_family?('debian')

# Use defaults in resources/server.rb
samba_server 'Samba Server' do
end

samba_user 'test_user_1' do
  password 'superawesomepassword'
  comment 'Samba Test User'
  home '/home/test_user_1'
  shell '/bin/bash'
end

samba_user 'test_user_2' do
  password 'anothertopsecretpassword'
  comment 'Samba Test User'
  shell '/bin/bash'
end

samba_share 'first_share' do
  comment 'exported share 1'
  path '/srv/export'
  guest_ok 'no'
  printable 'no'
  write_list ['test_user_1']
  create_mask '0644'
  directory_mask '0775'
end

samba_share 'second_share' do
  comment 'exported share 2'
  path '/srv/export_2'
  guest_ok 'no'
  printable 'no'
  write_list ['test_user_2']
  create_mask '0644'
  directory_mask '0775'
end
