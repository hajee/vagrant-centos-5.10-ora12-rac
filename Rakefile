
desc "Install all external content"
task :install_modules do
  sh "librarian-puppet install \-\-path=puppet/modules"
end

desc "Update all external content"
task :update_modules do
  sh "librarian-puppet update"
end

desc  "destroy both db nodes "
task :destroy       => ['destroy:db1', 'destroy:db2']

desc  "Create both db nodes "
task :db       => [:db1, :db2]

desc  "create db1 vagrant node"
task :db1       => ['up:db1','halt:db1','storage:db1']

desc  "create db2 vagrant node"
task :db2       => ['up:db2','halt:db2','storage:db2']

desc  "Up both nodes"
task :up        => ['up:db1','up:db2']


desc  "Provision both nodes"
task :provision        => ['provision:db1','provision:db2']

VDI_FILES = (1..7).collect {|i| "ssdisk#{i}.vdi"}


rule /\.vdi$/ do |vdi|
  sh "vboxmanage createhd --filename #{vdi} --size 4096 --variant Fixed"
end


desc "VM up tasks"
namespace :up do

  desc "Create db1 VM"
  task :db1 => VDI_FILES do
    sh "vagrant up db1 --provider=virtualbox --no-provision"
  end

  desc "Create db2 VM"
  task :db2 => VDI_FILES do
    sh "vagrant up db2 --provider=virtualbox --no-provision"
  end
end

desc "VM halt tasks"
namespace :halt do

  desc "Halt db1 VM"
  task :db1 do
    sh "vagrant halt db1 --force"
  end

  desc "Halt db2 VM"
  task :db2 do
    sh "vagrant halt db2 --force"
  end
end

desc "Provision VM's"
namespace :provision do

  desc "provision db1 VM"
  task :db1 do
    sh "vagrant provision db1"
  end

  desc "provision db2 VM"
  task :db2 do
    sh "vagrant provision db2"
  end
end


desc "VM destroy tasks"
namespace :destroy do

  desc "destroy db1 VM"
  task :db1 do
    sh "vagrant destroy db1"
  end

  desc "destroy db2 VM"
  task :db2 do
    sh "vagrant destroy db2"
  end
end


desc "Storagetasks"
namespace :storage do

  desc "configure db1"
  task :db1 do
    create_controller('db1')
    connect_disks('db1')
  end


  desc "configure db2"
  task :db2 do
    create_controller('db2')
    connect_disks('db2')
  end

end

def create_controller(vm)
  puts "Creating controller"
  sh "vboxmanage storagectl #{vm} --add sata --portcount 10 --name 'SATA Controller'"
end

def connect_disks(vm)
  controller_name = "SATA Controller"
  vdi_files = Dir.glob('*.vdi')
  vdi_files.each_with_index do |vdi_file, no|
    puts "Connect disk #{vdi_file}"
    sh "vboxmanage storageattach #{vm} --storagectl 'SATA Controller' --port #{no} --device 0 --type hdd --medium #{vdi_file} --mtype shareable"
  end
end

