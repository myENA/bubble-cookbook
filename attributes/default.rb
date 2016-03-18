# Override sudo attributes
default['authorization']['sudo']['groups'] = 'bubble', 'sysadmin'
default['authorization']['sudo']['users'] = []
default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['include_sudoers_d'] = false
default['authorization']['sudo']['agent_forwarding'] = true
default['authorization']['sudo']['sudoers_defaults'] = ['!lecture,tty_tickets,!fqdn']
default['authorization']['sudo']['command_aliases'] = []

# Customize chef-run
default['bubble']['users_databag'] = 'users'
default['bubble']['group_name'] = 'bubble'
default['bubble']['packages'] = true
default['bubble']['users'] = true
default['bubble']['sudo'] = true
default['bubble']['data_disk'] = false
default['bubble']['data_disk_device'] = 'vdb'
default['bubble']['nfs'] = true
default['bubble']['softethervpn-server'] = true
default['bubble']['softethervpn-config'] = 'vpn_normal.batch'
default['bubble']['softethervpn-psk'] = 'softether'
default['bubble']['community-templates'] = true
default['bubble']['cloudinit-metaserv'] = true
default['bubble']['cloudinit-password'] = 'password'
