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

describe ("check mariadb process listening on ip #{ ENV['CONN_HOST'] }:3306 ") do
  describe port(3306) do
    it { should be_listening.on("#{ ENV['CONN_HOST'] }") }
  end
end

describe ("check mariadb's root user is protected with password") do
  describe command("mysql -uroot -e \"show databases;\"") do
    its(:exit_status) { should_not eq 0 }
  end
end

describe ("check permissions for root user from any remote host") do
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for root@'%';\"") do
    its(:stdout) { should match /^\|\sGRANT ALL PRIVILEGES ON \*\.\* TO 'root'@'%' IDENTIFIED BY PASSWORD '.*' WITH GRANT OPTION\s\|$/ }
  end
end
