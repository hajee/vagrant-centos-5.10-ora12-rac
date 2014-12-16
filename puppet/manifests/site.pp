Package{allow_virtual => false,}

$instance     = 'example'

class rac_requirements{
  require fw
  contain ora_rac::interfaces
  contain ora_rac::os
  contain ora_rac::sysctl
  contain ora_rac::iptables
  contain ora_rac::hosts
  contain ora_rac::asm_drivers
  contain ora_rac::install
  contain ora_rac::swapspace  # If you have configured your swapspace, you don't need this

  file {'/install':
    ensure  => directory,
    recurse => false,
    replace => false,
    mode    => '0777',
  }

  file {'/opt/oracle':
    ensure  => directory,
    mode    => '0775',
    owner   => 'oracle',
    group   => 'oinstall',
  }


  #
  # MAke sure NTP is running and slewing option is enabled
  #
  package{'ntp': ensure => 'installed'} ->
  file{'/etc/sysconfig/ntpd':
    ensure  => 'file',
    source  => 'puppet:///modules/ora_rac/ntpd',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }~>
  service{'ntpd': ensure => 'running'}


}


node 'db1.example.com' {
  require rac_requirements
  require ora_rac::disk_config
  require ora_rac::disk_groups

  class {'ora_rac::db_master':}

  Class['rac_requirements'] -> Class['ora_rac::db_master']
}


node 'db2.example.com' {
  require rac_requirements
  require ora_rac::scandisks

  Class['rac_requirements'] -> Class['Ora_rac::scandisks'] ->
  class {'ora_rac::db_server':}
}
