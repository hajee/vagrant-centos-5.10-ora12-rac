Package{allow_virtual => false,}

$instance = 'example'

node 'rac_node' {
  require fw
  contain ora_rac::interfaces
  contain ora_rac::os
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
  contain ora_rac::config


  class {'ora_rac::db_master':
    require => [
      File['/opt/oracle'],
      Class[Ora_rac::Interfaces],
      Class[Ora_rac::Os],
      Class[Ora_rac::Hosts],
      Class[Ora_rac::Base],
      Class[Ora_rac::Install],
      Class[Ora_rac::Config],
      Class[Ora_rac::Swapspace],
    ]
  }
}


node 'db2.example.com' inherits 'rac_node'{
  contain ora_rac::scandisks

  class {'ora_rac::db_server':
    require => [
      File['/opt/oracle'],
      Class[Ora_rac::Interfaces],
      Class[Ora_rac::Os],
      Class[Ora_rac::Hosts],
      Class[Ora_rac::Base],
      Class[Ora_rac::Install],
      Class[Ora_rac::Scandisks],
      Class[Ora_rac::Swapspace],
    ]
  }
}
