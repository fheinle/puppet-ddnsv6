# set up ddnsv6 as a server
class ddns::server (
  Array   $domain_whitelist    = undef,
  String  $cloudflare_user     = undef,
  String  $cloudflare_password = undef,
  String  $ipv6_prefix         = '2001',
) {
  # install gem dependencies for the server portion
  $server_dependencies = {
    'sinatra'         => { 'ensure' => '2.0.0',   'provider' => 'gem' },
    'cloudflare'      => { 'ensure' => '3.1.0',   'provider' => 'gem' },
  }
  ensure_packages($server_dependencies)

  file { "ddns_config_server_${facts['fqdn']}":
    ensure  => present,
    path    => "${::ddns::install_directory}/ddnsv6.conf.yaml",
    owner   => $::ddns::ddns_user,
    mode    => '0640',
    content => template('ddns/ddnsv6-server.conf.yaml.erb'),
    require => Vcsrepo[$::ddns::install_directory]
  }

  cron { "ddns_worker_cron_${facts['fqdn']}":
    ensure   => present,
    command  => "${::ddns::install_directory}/worker.rb",
    hour     => '*',
    minute   => '*/10',
    monthday => '*',
    month    => '*',
    weekday  => '*',
    user     => $::ddns::ddns_user,
  }

  concat { "ddns::whitelist_${facts['fqdn']}":
    ensure         => present,
    ensure_newline => true,
    owner          => $::ddns::ddns_user,
    mode           => '0640',
    path           => "${::ddns::install_directory}/whitelist.txt",
    require        => Vcsrepo["${::ddns::install_directory}"]
  }

  Concat::Fragment <<| tag == "ddns::whitelist_${facts['fqdn']}" |>>
}
