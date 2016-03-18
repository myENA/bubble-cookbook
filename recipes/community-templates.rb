# Download and extract community templates
dest_path = '/data/templates'

templates = {
  'centos7.qcow2.bz2' => {
    checksum: 'http://dl.openvm.eu/cloudstack/centos/vanilla/7/x86_64/CentOS-7-x86_64-vanilla.sha1sum.txt',
    url: 'http://dl.openvm.eu/cloudstack/centos/vanilla/7/x86_64/CentOS-7-x86_64-vanilla-kvm.qcow2.bz2'
  },
  'tiny.qcow2.bz2' => {
    checksum: 'http://dl.openvm.eu/cloudstack/macchinina/x86_64/sha1sum.txt',
    url: 'http://dl.openvm.eu/cloudstack/macchinina/x86_64/macchinina-kvm.qcow2.bz2'
  },
  'systemvm64template-master-4.6.0-kvm.qcow2.bz2' => {
    checksum: 'https://cloudstack.o.auroraobjects.eu/systemvmtemplate/md5sum.txt',
    url: 'https://cloudstack.o.auroraobjects.eu/systemvmtemplate/systemvm64template-master-4.6.0-kvm.qcow2.bz2'
  }
}

# Create base directory for templates
directory dest_path do
  owner 'root'
  group node['bubble']['group_name']
  mode '0775'
  recursive true
  action :create
end

templates.each do |dest_name, urls|
  remote_file "#{dest_path}/#{dest_name}.checksum" do
    source "#{urls[:checksum]}"
    mode '0644'
    backup false
    notifies :create, "remote_file[#{dest_path}/#{dest_name}]", :immediately
  end

  remote_file "#{dest_path}/#{dest_name}" do
    source "#{urls[:url]}"
    mode '0644'
    backup false
    notifies :run, "bash[extract_file_#{dest_name}]", :immediately
    action :nothing
  end

  bash "extract_file_#{dest_name}" do
    cwd "#{dest_path}"
    code <<-EOF
    bunzip2 -k -f #{dest_name}
  EOF
    action :nothing
  end
end
