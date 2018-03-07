# set up ddnsv6 as a server
class ddns::server {
  file { "ddns_config_server_${facts['fqdn']}":
    ensure  => present,
    path    => "${::ddns::install_directory}/app/ddnsv6.conf.yaml",
    owner   => $::ddns::ddns_user,
    mode    => '0640',
    content => template('ddns/ddnsv6.conf.yaml.erb'),
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
