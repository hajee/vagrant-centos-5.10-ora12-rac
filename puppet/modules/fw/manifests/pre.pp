class fw::pre {
  Firewall {
    require => undef,
  }
   # Default firewall rules
  firewall { '000 accept all to lo interface':
    chain   => 'RH-Firewall-1-INPUT',
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '001 accept all icmp':
    chain   => 'RH-Firewall-1-INPUT',
    proto   => 'icmp',
    action  => 'accept',
  }

  firewall { '002 accept related established rules':
    chain   => 'RH-Firewall-1-INPUT',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }

  firewall { '003 allow SSH access':
    port   => 22,
    proto  => tcp,
    action => accept,
  }
}

