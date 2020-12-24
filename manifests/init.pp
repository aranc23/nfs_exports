# @summary manage entries in /etc/exports
#
# Along with a defined type (nfs::exports::export) manages 
# entries in /etc/exports and subsequently invokes exportfs.
#
# @param etc_exports
#   path to file to apply changes to (/etc/exports)
# @param exportfs
#   command to invoke after changes to exports file
# @param exportfs_path
#   passed to the exec used to invoke exportfs
# @param exports
#   hash with index of the path of the export, and a key
#   consisting of an array of client structs, see below for example
#
# @example Class usage
#   class { '::nfs_exports':
#     exports => {
#       '/data'     => [
#         { client => 'testvm.example.com', options => ['rw'] },
#         { client => 'roclient.example.com', options => ['ro'] },
#       ],
#     },
#   }
class nfs_exports
(
  Stdlib::Absolutepath $etc_exports,
  String $exportfs,
  Array[Stdlib::Absolutepath] $exportfs_path,
  Hash[String,Array[Struct[{
    client  => String,
    options => Optional[Variant[String,Array[String]]]
  }]]] $exports = {}
)
{
  $exports.each |String $path,Array $clients| {
    nfs_exports::export { $path:
      clients => $clients,
    }
  }
  exec { $exportfs:
    refreshonly => true,
    path        => $exportfs_path,
  }
}

