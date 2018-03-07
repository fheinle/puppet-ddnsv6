# install ddnsv6 and its dependencies
class ddns::install {
  if $::ddns::create_ddns_user {
    user { $::ddns::ddns_user:
      ensure => present,
    }
  }
  vcsrepo { "${::ddns::install_directory}/app":
    ensure   => present,
    provider => 'git',
    source   => $::ddns::install_repo,
    revision => $::ddns::ddns_version,
    owner    => $::ddns::ddns_user,
  }

  $dependencies = {
    'ruby-dev'        => { 'ensure' => 'present', 'provider' => 'apt' },
    'libsystemd-dev'  => { 'ensure' => 'present', 'provider' => 'apt' },
    'cloudflare'      => { 'ensure' => '3.1.0',   'provider' => 'gem' },
    'journald-logger' => { 'ensure' => '2.0.3',   'provider' => 'gem' },
    'sinatra'         => { 'ensure' => '2.0.0',   'provider' => 'gem' },
  }
  ensure_packages($dependencies)
}
