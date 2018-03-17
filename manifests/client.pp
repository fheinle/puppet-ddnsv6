# set up ddnsv6 as a client
class ddns::client (
  String  $ddns_server         = undef,
  Boolean $ddns_server_ssl     = true,
  Integer $ddns_server_port    = 443,
  String  $client_username     = 'ddns',
  String  $client_password     = undef,
  String  $ipv6_prefix         = '2001',
) {
  file { "ddns_config_client_${facts['fqdn']}":
    ensure  => present,
    path    => "${::ddns::install_directory}/ddnsv6.conf.yaml",
    owner   => $::ddns::ddns_user,
    mode    => '0640',
    content => template('ddns/ddnsv6-client.conf.yaml.erb'),
    require => Vcsrepo[$::ddns::install_directory]
  }

  cron { "ddns_cron_${facts['fqdn']}":
    ensure      => present,
    command     => "${::ddns::install_directory}/client.rb",
    environment => "DDNS_IFACE=${facts['networking']['primary']}",
    hour        => '*',
    minute      => '*/5',
    monthday    => '*',
    month       => '*',
    weekday     => '*',
    user        => $::ddns::ddns_user,
  }
}
