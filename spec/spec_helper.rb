require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :request_pty, true

options = {}

options[:host_name] = ENV['CONN_HOST']
options[:user] = ENV['CONN_USER'] 
options[:password] = ENV['CONN_PASS'] || ''
options[:port] = ENV['CONN_PORT'] || '22'
options[:keys] = ENV['CONN_IDKEY'] || ''
options[:paranoid] = false
options[:user_known_hosts_file] = '/dev/null'

set :ssh_options, options

if ENV['SUDO_PASS'] != nil
  set :sudo_password, ENV['SUDO_PASS']
end

