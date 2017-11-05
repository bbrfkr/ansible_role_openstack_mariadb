puts ("==============================")
puts ("Role test")
puts ("openstack_mariadb: #{ ENV['CONN_NAME'] }")
puts ("==============================")

system("cd spec && rm -rf host_vars")
system("cd spec && cp -r host_vars_dirs/host_vars_01 host_vars")
system("cd spec && ansible-playbook -i inventory site.yml")

require 'spec_helper'
file_dir = File.dirname(__FILE__)

describe ("check necessary packages are installed") do
  packages = ["mariadb", "mariadb-server", "python2-PyMySQL", "expect", "MySQL-python"]
  packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe ("check mariadb service is enabled and started") do
  describe service("mariadb") do
    it { should be_running }
    it { should be_enabled }
  end
end

describe ("check mariadb process listening on ip 192.168.1.115:3306") do
  describe port(3306) do
    it { should be_listening.on("192.168.1.115") }
  end
end

describe ("check mariadb's root user is protected with password") do
  describe command("mysql -uroot -e \"show databases;\"") do
    its(:stdout) { should match /Access denied for user 'root'@'localhost' \(using password: NO\)/ }
  end
end

describe ("check permissions for root user from any remote host") do
  describe command("mysql -u root -ppassword -e \"show grants for root@'%';\"") do
    its(:stdout) { should match /^\|\sGRANT ALL PRIVILEGES ON \*\.\* TO 'root'@'%' IDENTIFIED BY PASSWORD '.*' WITH GRANT OPTION\s\|$/ }
  end
end

