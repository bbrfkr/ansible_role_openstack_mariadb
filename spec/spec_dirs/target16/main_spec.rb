puts ("==============================")
puts ("Role test")
puts ("openstack_mariadb: #{ ENV['CONN_NAME'] }")
puts ("==============================")

system("cd spec && rm -rf host_vars")
system("cd spec && cp -r host_vars_dirs/host_vars_01 host_vars")
system("cd spec && ansible-playbook -i inventory site.yml")

require 'spec_helper'
file_dir = File.dirname(__FILE__)

describe ("check mariadb process listening on ip #{ ENV['CONN_HOST'] }:3306 ") do
  describe port(3306) do
    it { should be_listening.on("#{ ENV['CONN_HOST'] }") }
  end
end

describe ("check non-permissions for root user from any remote host") do
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for root@'%';\"") do
    its(:stdout) { should match /There is no such grant defined for user 'root' on host '%'/ }
  end
end
