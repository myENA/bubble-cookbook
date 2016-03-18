require 'spec_helper'

describe 'bubble::default' do
  describe service('libvirtd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('curl -s http://127.0.0.1:8080') do
    its(:stdout) { should contain('password') }
  end

  describe command('curl -s http://127.0.0.1/latest/meta-data/instance-id') do
    its(:stdout) { should match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) }
  end

  describe command('virsh net-list') do
    its(:stdout) { should match(/NAT\s+active/)}
  end

end
