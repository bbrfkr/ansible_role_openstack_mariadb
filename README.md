# ansible_role_openstack_mariadb

This is an Ansible role. This role executes MariaDB settings for OpenStack environment.

## Processing
This role executes the following settings.

* MariaDB setting
  * register openstack repository
  * install necessary packages
  * set mariadb config
  * set mariadb service enabled and started
  * execute mysql_secure_installation
  * set mariadb allowed for root user to connect from remote host

## Caution!!
* This role assumpts a part of network settings (nics, default gateway and dns server) is completed.
* This role assumpts NetworkManager service is disabled and stopped.

## Support OpenStack release
* Ocata

## Support OS

| OS | version |
|----|---------|
|CentOS|7|

## Role variables
```
openstack_mariadb:
  listen_addr: 192.168.1.115      # address on which mariadb service listens
  db_root_pass: p@ssw0rd          # password of MariaDB's root user
  remote_connect:                 # settings for remote connect (optional)
    remote_host: "%"              # target host for connecting remotely
    allow_connect: yes            # whether allow to connect from remote host or not
```

## Dependencies
- [bbrfkr.openstack_common](https://galaxy.ansible.com/bbrfkr/openstack_common/)

## Build status
|branch|status|
|------|------|
|master|[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_openstack_mariadb_master/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_openstack_mariadb_master/)|
|ocata |[![Build Status](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_openstack_mariadb_ocata/badge/icon)](http://jenkins.bbrfkr.mydns.jp:8088/job/ansible_role_openstack_mariadb_ocata/)|

## Retest
This role is tested by serverspec, then its test codes are included in repository. Users can retest this role by using the test codes. To retest this role, follow the steps described below.

1. Prepare targets (Here, targets ip are X.X.X.X, Y.Y.Y.Y, Z.Z.Z.Z)
2. Install serverspec in local machine
3. Modify spec/inventory.yml
```
---
- conn_name: target15  # never change!
  conn_host: X.X.X.X   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key 
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user

- conn_name: target16  # never change!
  conn_host: Y.Y.Y.Y   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user

- conn_name: target17  # never change!
  conn_host: Z.Z.Z.Z   # target ip
  conn_port: 22        # target's ssh port
  conn_user: vagrant   # user to connect
  conn_pass: vagrant   # password of user
  conn_idkey:          # path of identity key
                       # (absolute path or relative path from the location of Rakefile)
  sudo_pass:           # sudo password of user
```
4. Modify targets ips in any files of `spec` dir
```
$ sed -i 's/192\.168\.1\.115/X.X.X.X/g' `find spec -type f`
$ sed -i 's/192\.168\.1\.116/Y.Y.Y.Y/g' `find spec -type f`
$ sed -i 's/192\.168\.1\.117/Z.Z.Z.Z/g' `find spec -type f`
```

5. Run `rake`

## License
MIT

## Author
Name: bbrfkr  
MAIL: bbrfkr@gmail.com

