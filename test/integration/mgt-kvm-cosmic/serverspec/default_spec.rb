require 'spec_helper'

ssh_pass = 'sshpass -p password ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@cs1 '
prepare_compile = ssh_pass + '"cd /data/shared/helper_scripts/cosmic; ./prepare_cosmic_compile.sh -h; ./prepare_cosmic_compile.sh -h"'
build_run_deploy_test = ssh_pass + '"cd /data/shared/helper_scripts/cosmic; ./build_run_deploy_test.sh -m /data/shared/marvin/mct-zone1-kvm1.cfg"'
keep_running = ssh_pass + '"cd /data/git/cs1/cosmic/cosmic-client; screen -dml mvn -pl :cloud-client-ui jetty:run > jetty.log 2>&1 ; sleep 3 "'

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

  describe command('brctl show') do
    its(:stdout) { should contain('tap_vpn')}
    its(:stdout) { should contain('virbr0-nic')}
  end

  describe command('cd /data/shared/deploy; ./kvm_local_deploy.py --deploy-role cloudstack-mgt-dev -d 1 --force') do
    its(:stdout) {should contain('Examining the guest')}
    its(:stdout) {should contain('Installing firstboot script')}
    its(:stdout) {should contain('Finishing off')}
    its(:stdout) {should contain('Running postboot script')}
    its(:stdout) {should contain('Installing and configuring')}
    its(:stdout) {should contain('Ready for duty!')}
  end

  describe command('sshpass -p password ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@cs1 "mount | grep data"') do
    its(:stdout) {should contain('192.168.22.1:/data')}
  end

  describe command('cd /data/shared/deploy; ./kvm_local_deploy.py --deploy-role  kvm --digit 1 --force') do
    its(:stdout) {should contain('Examining the guest')}
    its(:stdout) {should contain('Installing firstboot script')}
    its(:stdout) {should contain('Finishing off')}
    its(:stdout) {should contain('Running postboot script')}
    its(:stdout) {should contain('Installing and configuring')}
    its(:stdout) {should contain('Ready for duty!')}
  end

  describe command('sshpass -p password ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@kvm1 "mount | grep data"') do
    its(:stdout) {should contain('192.168.22.1:/data')}
  end

  describe command(prepare_compile) do
    its(:stdout) {should contain('Git Cosmic repo already found')}
    its(:stdout) {should contain('/data/git/cs1/cosmic')}
  end

  describe command(build_run_deploy_test) do
    its(:stdout) {should contain('====Deploy DC Successful=====')}
    its(:stdout) {should contain('All templates are ready!')}
    its(:stdout) {should contain('Finished')}
  end

  describe command(keep_running) do
    its(:exit_status) { should eq 0 }
  end
end
