# Recipes controlled by attributes
include_recipe 'bubble::packages' if node['bubble']['packages']
include_recipe 'bubble::users' if node['bubble']['users']
include_recipe 'bubble::data_disk' if node['bubble']['data_disk']
include_recipe 'bubble::nfs' if node['bubble']['nfs']
include_recipe 'bubble::community-templates' if node['bubble']['community-templates']
include_recipe 'bubble::softethervpn-server' if node['bubble']['softethervpn-server']
include_recipe 'bubble::internal-templates' if node['bubble']['internal-templates']
include_recipe 'bubble::cloudinit-metaserv' if node['bubble']['cloudinit-metaserv']
include_recipe 'sudo' if node['bubble']['sudo']

# Copy KVM configuration files
remote_directory '/tmp/libvirt' do
  source 'libvirt'
end

cookbook_file '/etc/modprobe.d/kvm-nested.conf' do
  source 'kvm/kvm-nested.conf'
  owner 'root'
  group 'root'
  mode 00644
end

# Copy virbr0.50 and vpn tap device vlan network configuration
remote_directory '/etc/sysconfig/network-scripts' do
  source 'network'
end

# Copy rc.local for delayed initialization of virbr0.50 and vpn interface
cookbook_file '/etc/rc.local' do
  source 'rc.local/rc.local'
  owner 'root'
  group 'root'
  mode 0755
end

# Copy ssh_config to manage global SSH settings
cookbook_file '/etc/ssh/ssh_config' do
  source 'ssh/ssh_config'
  owner 'root'
  group 'root'
  mode 0644
end

# Copy dhclient.conf to resolve via the libvirt dns
cookbook_file '/etc/dhcp/dhclient.conf' do
  source 'dhcp/dhclient.conf'
  owner 'root'
  group 'root'
  mode 00644
  action :create_if_missing
end

# Copy polkit configurtion to let user use virt-manager
template '/etc/polkit-1/localauthority/50-local.d/50-libvirt.pkla' do
  source '50-libvirt.pkla.erb'
  variables(
    group_name: node['bubble']['group_name']
  )
end

# Set LIBVIRT environment to make a user use virsh
cookbook_file '/etc/profile.d/libvirt.sh' do
  source 'profile.d/libvirt.sh'
  owner 'root'
  group 'root'
  mode 0755
  action :create_if_missing
end

# Restart network after libvirtd
service 'network' do
  action :nothing
end

# Enable and start libvirtd
service 'libvirtd' do
  action [:start, :enable]
  notifies :restart, 'service[network]'
end

# Import libvirt configurations
bash 'Configure_NAT_network' do
  user 'root'
  cwd '/tmp/libvirt'
  code <<-EOH
  virsh net-destroy default
  virsh net-undefine default
  virsh net-define net_NAT.xml
  virsh net-start NAT
  virsh net-autostart NAT
EOH
  not_if { ::File.exist?('/etc/libvirt/qemu/networks/NAT.xml') }
end

bash 'Configure_default_images_dir' do
  user 'root'
  cwd '/tmp/libvirt'
  code <<-EOH
   virsh pool-destroy default
   virsh pool-undefine default
   virsh pool-define pool_images.xml
   virsh pool-autostart default
   virsh pool-build default
   virsh pool-start default
EOH
  not_if { ::File.exist?('/etc/libvirt/storage/autostart/default.xml') }
end

bash 'Configure_default_iso_dir' do
  user 'root'
  cwd '/tmp/libvirt'
  code <<-EOH
   virsh pool-destroy iso
   virsh pool-define pool_iso.xml
   virsh pool-autostart iso
   virsh pool-build iso
   virsh pool-start iso
EOH
  not_if { ::File.exist?('/etc/libvirt/storage/autostart/iso.xml') }
end

# Create base directory structure on /data
%w( /data/iso /data/images /data/git ).each do |path|
  directory path do
    owner 'root'
    group node['bubble']['group_name']
    mode '0775'
    recursive true
    action :create
  end
end

# Sync the MCT shared repository
git '/data/shared' do
  repository 'https://github.com/MissionCriticalCloud/bubble-toolkit.git'
  revision 'master'
  group node['bubble']['group_name']
  action :sync
end

# Install python clint for kvm_local_deploy
python_pip 'clint'
