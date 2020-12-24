# @summary fully manage an entry in /etc/exports 
#
# Manages one export entry in /etc/exports,
# completelely replacing any existing hosts for that entry.
#
# @param clients
#   struct containing a client string (netgroup, ip address, etc.)
#   and an optional options array.  If the client is - it is treated
#   as a defaults entry and the options are not enclosed in parenthesis
#   see the exports man page on your system for details
# 
# @example Typical usage
#   nfs_exports::export { '/data':
#     clients => [
#       { client => '-', options => ['ro'] },
#       { client => 'example.com'},
#       { client => 'other.example.com', options => 'rw'},
#    ],
#   }
# should produce:
#   /data -ro example.com other.example.com(rw)
define nfs_exports::export
(
  Array[Struct[{
    client  => String,
    options => Optional[Variant[String,Array[String]]]
  }]] $clients = [],
)
{
  include ::nfs_exports
  #assert_type(Stdlib::Absolutepath,$title)
  unless($title =~ Stdlib::Absolutepath) {
    # this seems more clear when it does fail than above,
    # because the assert_type output can be hard to parse
    fail("resource title must be an absolute path: ${title}")
  }

  file_line { "update export entry for ${title} in ${nfs_exports::etc_exports}":
    path   => $nfs_exports::etc_exports,
    line   => template('nfs_exports/export.erb'),
    match  => "^${title}\s*",
    notify => Exec[$nfs_exports::exportfs]
  }

}
