# set up ddnsv6 as a server
class ddns::server (
  Array   $domain_whitelist    = undef,
  String  $cloudflare_user     = undef,
  String  $cloudflare_password = undef,
) {
  # install gem dependencies for the server portion
  $server_dependencies = {
    'sinatra'         => { 'ensure' => '2.0.0',   'provider' => 'gem' },
    'cloudflare'      => { 'ensure' => '3.1.0',   'provider' => 'gem' },
  }
  ensure_packages($server_dependencies)

  file { "ddns_config_server_${facts['fqdn']}":
    ensure  => present,
    path    => "${::ddns::install_directory}/app/ddnsv6.conf.yaml",
    owner   => $::ddns::ddns_user,
    mode    => '0640',
    content => template('ddns/ddnsv6-server.conf.yaml.erb'),
  }

  cron {"ddns_worker_cronjob_${facts['fqdn']}":
    command  => "/usr/bin/ruby/${::ddns::install_directory}/app/worker.rb",
    user     => $::ddns::ddns_user,
    minute   => '*/12',
    hour     => '*',
    monthday => '*',
    month    => '*',
    weekday  => '*',
  }
}
