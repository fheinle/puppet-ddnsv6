# set up ddnsv6 as a client
class ddns::client {
  file { "ddns_config_client_${facts['fqdn']}":
    ensure  => present,
    path    => "${::ddns::install_directory}/app/ddnsv6.conf.yaml",
    owner   => $::ddns::ddns_user,
    mode    => '0640',
    content => template('ddns/ddnsv6.conf.yaml.erb'),
  }

  cron { "ddns_client_cronjob_${facts['fqdn']}":
    command     => "/usr/bin/ruby/${::ddns::install_directory}/app/client.rb",
    user        => $::ddns::ddns_user,
    minute      => '*/5',
    hour        => '*',
    monthday    => '*',
    month       => '*',
    weekday     => '*',
    environment => "DDNS_IFACE=${facts['networking.primary']}",
  }
}