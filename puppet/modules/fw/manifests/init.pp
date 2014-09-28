class fw {
  resources { "firewall":
    purge => true
  }
  Firewall {
    before  => Class['fw::post'],
    require => Class['fw::pre'],
  }
  class { ['fw::pre', 'fw::post']: }
  class { 'firewall': }
}