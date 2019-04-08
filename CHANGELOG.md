# Samba Changelog

## Unreleased

## v2.0.0 (2019-04-08)

- Remove licence headers from files
- Remove server recipe
- Add CircleCI builder
- Add level configurable to the template

## v1.2.0 (2018-09-22)

- Update platforms
- Remove shaddow password test that was unreliable
- Drop Chef-12 support

## v1.1.4 (2018-07-22)

- Fix bind interfaces

## v1.1.3 (2018-06-05)

- Honour the `max_size` property (#84, @sll552)

## v1.1.2 (2018-03-28)

- Make the password property sensitive so it doesn't appear in the output log (#83)

## v1.1.1 (2017-12-06)

- Add optional, options to the share resource (#80)

## v1.1.0 (2017-08-02)

- Add realm property
- Add encrypt_passwords property
- Add kerberos_method property
- Add log_level property
- Add winbind_separator property
- Add idmap_config property
- Add valid_users property
- Add force_group property
- Add browseable property
- Many rubocop fixes (though not all)
- Change share options from required that weren't really required
- Fix issue with directory creation when path was not defined (which is not required for home dirs for instance)
- Make winbind_separator optional in template as default backslash is a continuation character in smb.conf
- Extend tests

## v1.0.6 (2017-07-24)

- Require Chef 12.16+ #73
- Update README with clear intentions of the `samba_user` resource. #
- Fix OpenSUSE client install #75

## v1.0.5 (2017-04-21)

- Fix user resource to generate a correct user password.
- Fix options Hash #66

## v1.0.4 (2017-04-06)

- Add `read_only` option to share. (#62 @whatcould)

## v1.0.3 (2017-02-25)

- Fixes double converges for smb.conf
- Remove 16.04 from travis test matrix whilst we investigate long term solutions to failures
- Adds Service tests
- Remove ChefSpec matchers to tidy for tidy up

## v1.0.2 (2017-04-02)

- Fix #54 Add an option to not create the directory we add to the share. Useful for including Samba variables in the share name.
- Fix #52 nmbd systemd failures in tests.

## v1.0.1 (2017-04-02)

- Fix #48 Resource underscores breaking permissions
- Fix #47 Document proper behaviour of smbpasswd. This cookbook now enforces passwords.

## v1.0.0 (2017-01-03)

- New custom resources `samba_server`, `samba_share`, `samba_user`
- Remove data bags!
- Removed support for Arch & SmartOS
- Add 12.1 compatibility requirement
- Move attributes out of template file and into template resource
- Use Chef built in apt-get functionality
- Remove default recipe - having a default recipe can be misleading when it doesn't do anything.
- Guard against nil options & shares
- Update README with resources and give it a general tidy.
- Remove default specs
- Use root context for template and services
- Use trusty not precise for building on travis-ci
- Remove spec directory as it duplicates inspec test & doesn't test what's now in the cookbook
- Move yum into the testing recipe to clean up dependancies.
- Ignore FC009 as it isn't being picked up correctly.

## v0.13.0 (2016-12-30)

- This cookbook is now maintained by Sous Chefs (sous-chefs.org). Expect regular updates and quicker turnaround on PRs!
- This will be the last version of this cookbook that supports Chef 11\. Pin to this version if you require Chef 11 compatibility
- Added node["samba"]["options"] for passing an array of additional options
- Added node['samba']['enable_users_search'] to enable/disable searching for samba users. Defaults to true to maintain existing behavior.
- Added SmartOS compatibility
- Added ChefSpec matchers for the LWRP
- Added `source_url` `issues_url` and `chef_version` metadata
- Removed arch and raspbian from the metadata and added oracle. We officially support systems we can test with Test Kitchen only.
- Added a Rakefile for simplified testing
- Switched integration testing to Inspec from serverspec
- Moved all testing to the 'test' cookbook and eliminated the need for the apt cookbook
- Switched to cookstyle from Rubocop and resolved all warnings
- Added testing in Travis CI
- Added a kitchen config for kitchen-dokken. Expect testing in Travis using kitchen-dokken soon
- Added a Code of Conduct doc
- Updated the Contributing docs

## v0.12.0

- Manage services at end of server recipe
- Move package and service names to attributes
- Select data bags via attributes instead of hardcoded names
- Corrected service name on Debian
- Add map to guest option in smb.conf
- Add test kitchen, chefspec, serverspec, rubocop ignore rules, and foodcritic check
- Cleanup attributes to make them easier to follow per-platform

## v0.11.4

- [COOK-3144]: Wrong service name in samba cookbook

## v0.11.2

- [COOK-2978]: samba cookbook has foodcritic errors

## v0.11.0

- [COOK-1719] - Add Scientific / Amazon support to the Samba recipe

## v0.10.6

- [COOK-1363] - user password assignment fails on systems using dash as default shell

## v0.10.4

- Fixes COOK-802, typo in nmbd service name
