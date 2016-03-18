Bubble cookbook
==============================
This cookbook installs all components to run a development environment based on KVM nested hypervising.

This "bubble" is the base for using all tools that are located in the bubble-toolkit to do development on Cosmic and Apache Cloudstack. It gives the developer the opportunity to write, run and test his code agains "real" hardware.

![bubble running](https://cloud.githubusercontent.com/assets/1392945/13878645/09e3e1ee-ed13-11e5-9119-c7dc595e5cbb.png)
![bubble nuc](https://cloud.githubusercontent.com/assets/1392945/13878657/1e19cb2e-ed13-11e5-8dff-0f4f3855196a.png)

Requirements
------------
The "bubble" has been developed on CentOS 7.x and has no plans to support other distributions yet.

The following requirements need to be met:

* Intel based processor that supports virtualization (Haswell or better recommended)
* 100+GB Harddrive (for templates and sourcecode)
* Centos 7(.2) Minimal installation (adjust disk layout to provide /data dir)

Attributes
----------
* `node['bubble']['users_databag']` - The databag that contains the users created (users)
* `node['bubble']['group_name']` - The groupname of the user(s) to allow users to create/delete virtual machines (bubble)
* `node['bubble']['packages']` - This enables/disables the packages recipe (true)
* `node['bubble']['users']` - This enables/disables the user creation recipe (true)
* `node['bubble']['sudo']` - This enables/disables the sudo recipe to give the created users sudo rights (true)
* `node['bubble']['data_disk']` - This allows for the addition of an extra disk that contains /data (false)
* `node['bubble']['data_disk_device']` - This is the name of the device (e.g /dev/hdb) (vdb)
* `node['bubble']['nfs']` - This enables/disables the nfs recipe that provides the nfs server in the bubble (true)
* `node['bubble']['softethervpn-server']` - This enables/disables the softethervpn server to reach the vm's in virbr0 (true)
* `node['bubble']['softethervpn-config']` - The configuration file used for softethervpn
* `node['bubble']['softethervpn-psk']` - The preshared key used in the L2TP vpn confuguration (softether)
* `node['bubble']['community-templates']` - This enables/disables the download of templates in the community (true)
* `node['bubble']['cloudinit-metaserv']` - This enables/disables the metaserver to serve cloud-init configuration (true)
* `node['bubble']['cloudinit-password']` - This password sent to the virtual machines via cloud-init (password)

Usage
-----
TODO

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
License: Apache Version 2.0

Authors:
* Fred Neubauer
* Remi Bergsma
* Bob van den Heuvel
* Boris Schrijver
* Miguel Ferreira
* Wilder Rodrigues
