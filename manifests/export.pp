# @summary fully manage an entry in /etc/exports 
#
# Manages one export entry in /etc/exports,
# completelely replacing any existing hosts for that entry.
#
# @example
#   nfs_exports::export { '/data':
#    clients => [{client => 'example.com'},
#                {client => 'other.example.com',
#                 options => 'rw'} ],
#     default_options => ['ro'],
#    }
define nfs_exports::export
(
  String $etc_exports = '/etc/exports',
  String $exportfs = 'exportfs -ra',
  Array[String] $exportfs_path = ['/sbin','/usr/sbin'],
  Array[Struct[{
    client  => String,
    options => Optional[Variant[String,Array[String]]]
  }]] $clients = [],
  Optional[Variant[String,Array[String]]] $default_options = [],
)
{
  file_line { "update export entry for ${title} in ${etc_exports}":
    path  => $etc_exports,
    line  => template('nfs_exports/export.erb'),
    match => "^${title}\s*",
  }
  ~> exec { $exportfs:
    refreshonly => true,
    path        => $exportfs_path,
  }
}
