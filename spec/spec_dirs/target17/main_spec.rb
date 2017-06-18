puts ("==============================")
puts ("Role test")
puts ("openstack_mariadb: #{ ENV['CONN_NAME'] }")
puts ("==============================")

system("cd spec && rm -rf host_vars")
system("cd spec && cp -r host_vars_dirs/host_vars_01 host_vars")
system("cd spec && ansible-playbook -i inventory site.yml")

require 'spec_helper'
file_dir = File.dirname(__FILE__)

describe ("check mariadb process listening on ip 192.168.1.117:3306 ") do
  describe port(3306) do
    it { should be_listening.on("192.168.1.117") }
  end
end

describe ("check permissions for root user from localhost") do
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for root@'localhost';\"") do
    its(:stdout) { should match /^\|\s+GRANT ALL PRIVILEGES ON \*\.\* TO 'root'@'localhost' IDENTIFIED BY PASSWORD '.*' WITH GRANT OPTION\s+\|$/ }
  end
end

describe ("check non-permissions for root user from any remote host") do
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for root@'%';\"") do
    its(:stdout) { should match /There is no such grant defined for user 'root' on host '%'/ }
  end
end
