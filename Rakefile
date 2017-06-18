require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

def generate_ansible_inventory(name, host, port, user, pass, idkey, sudo_pass)
  ansible_inventory = name
  ansible_inventory += " ansible_host=#{ host }"
  ansible_inventory += " ansible_port=#{ port || 22 }"
  ansible_inventory += " ansible_user=#{ user || root }"
  if pass != nil
    ansible_inventory += " ansible_ssh_pass=#{ pass }"
  end
  if idkey != nil
    ansible_inventory += " ansible_ssh_private_key_file=#{ pass }"
  end
  if sudo_pass != nil
    ansible_inventory += " ansible_become_pass=#{ sudo_pass }"
  end

  return ansible_inventory
end

def copy_role_for_spec
  copy_dest = "spec/roles/openstack_mariadb"
  if not Dir.exist?(copy_dest)
    FileUtils.mkdir_p(copy_dest)
  end
  delete_targets = Dir.glob(copy_dest + '/*')
  FileUtils.rm_rf(delete_targets)
  copy_targets = Dir.glob('*')
  copy_targets.delete('spec')
  FileUtils.cp_r(copy_targets, copy_dest)
end

def clone_common_role_for_spec
  copy_dest = "spec/roles/bbrfkr.openstack_common"
  if not Dir.exist?(copy_dest)
    FileUtils.mkdir_p(copy_dest)
  end
  delete_targets = Dir.glob(copy_dest)
  FileUtils.rm_rf(delete_targets)
  system("cd spec/roles && git clone https://github.com/bbrfkr/ansible_role_openstack_common.git bbrfkr.openstack_common")
  system("cd spec/roles/bbrfkr.openstack_common && git checkout -b ocata origin/ocata")
end

task :default => :spec
task :spec => 'spec:all'

namespace :spec do
  connections = YAML.load_file("spec/inventory.yml")

  conn_hosts = []
  connections.each do |connection|
    conn_hosts.push(connection['conn_name'])
  end

  task :all => conn_hosts

  copy_role_for_spec
  clone_common_role_for_spec

  connections.each do |connection|

    desc "Run serverspec to the connection for test #{ connection['conn_name']}"
    RSpec::Core::RakeTask.new(connection['conn_name'].to_sym) do |t|
      ENV['CONN_NAME'] = connection['conn_name']
      ENV['CONN_HOST'] = connection['conn_host']
      ENV['CONN_PORT'] = connection['conn_port'].to_s || '22'
      ENV['CONN_USER'] = connection['conn_user'] || 'root'
      ENV['CONN_PASS'] = connection['conn_pass']
      ENV['CONN_IDKEY'] = connection['conn_idkey']
      ENV['SUDO_PASS'] = connection['sudo_pass']
      File.open('spec/inventory', 'w') do |f|
        ansible_inventory = generate_ansible_inventory(connection['conn_name'],
                                                       connection['conn_host'],
                                                       connection['conn_port'],
                                                       connection['conn_user'],
                                                       connection['conn_pass'],
                                                       connection['conn_idkey'],
                                                       connection['sudo_pass'])
        f.puts(ansible_inventory)
      end

      t.pattern = "spec/spec_dirs/#{ connection['conn_name'] }/*_spec.rb"
    end
  end
end

