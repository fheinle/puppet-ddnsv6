# ddns
#
# Install [dyndnsv6](https://github.com/fheinle/ddnsv6)
#
# The main class will install dependencies
# To install the server or client part, check the respective classes.
class ddns (
  String  $install_directory = '/opt/ddnsv6',
  String  $install_repo      = 'https://github.com/fheinle/ddnsv6',
  String  $install_version   = 'master',
  String  $ddns_user         = 'ddns',
  Boolean $create_ddns_user  = true,
) {
  # maybe you create it in some kind of directory instead
  if $create_ddns_user {
    user { $ddns_user:
      ensure => present,
    }
  }

  vcsrepo { "${install_directory}/app":
    ensure   => present,
    provider => 'git',
    source   => $install_repo,
    revision => $install_version,
    owner    => $ddns_user,
  }

  $dependencies = {
    'ruby-dev'        => { 'ensure' => 'present', 'provider' => 'apt' },
    'libsystemd-dev'  => { 'ensure' => 'present', 'provider' => 'apt' },
    'journald-logger' => { 'ensure' => '2.0.3',   'provider' => 'gem' },
  }
  ensure_packages($dependencies)
}
