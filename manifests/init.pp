# ddns
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include ddns
class ddns (
  String  $install_directory = '/opt/ddnsv6',
  String  $install_repo      = 'https://github.com/fheinle/ddnsv6',
  String  $ddns_user         = 'ddns',
  String  $ddns_version      = 'master',
  Boolean $create_ddns_user  = true,
  Boolean $setup_server      = false,
  Boolean $setup_client      = true,
  String  $ddns_server       = undef,
  Array   $domain_whitelist  = undef,
  Array   $host_whitelist    = undef,
) {

  include ::ddns::install
}
