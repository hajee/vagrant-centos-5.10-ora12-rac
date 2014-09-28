class fw::post {
  firewall { '999 icmp host prohibited':
  	chain   => 'RH-Firewall-1-INPUT',
    action  => 'reject',
	reject => 'icmp-host-prohibited',
    before  => undef,
  }
}

