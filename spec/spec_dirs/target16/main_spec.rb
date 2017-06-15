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

