Package{allow_virtual => false,}

$instance     = 'example'
$requirements = [
      File['/opt/oracle'],
      Class[Ora_rac::Interfaces],
      Class[Ora_rac::Os],
      Class[Ora_Rac::Sysctl],
      Class[Ora_rac::Hosts],
      Class[Ora_rac::Base],
      Class[Ora_rac::Install],
      Class[Ora_rac::Swapspace],
    ]


node 'rac_node' {
  require fw
  contain ora_rac::interfaces
  contain ora_rac::os
  contain ora_rac::sysctl
  contain ora_rac::iptables
  contain ora_rac::hosts
  contain ora_rac::base
  contain ora_rac::install
  contain ora_rac::swapspace  # If you have configured your swapspace, you don't need this

  file {'/opt/oracle':
    ensure => directory,
    owner  => 'oracle',
    group  => 'oinstall',
    mode   => '0775',
  }

  file {'/install':
    ensure  => directory,
    recurse => false,
    replace => false,
    mode    => '0777',
  }
}

node 'db1.example.com' inherits 'rac_node'{
  require ora_rac::config
  require ora_rac::disk_groups
  $db1_requirements = $requirements + [Class[Ora_rac::Config]]
  class {'ora_rac::db_master':
    require => $db1_requirements,
  }
}


node 'db2.example.com' inherits 'rac_node'{
  contain ora_rac::scandisks

  class {'ora_rac::db_server':
    require => $requirements,
  }
}
