# nfs_exports

Updates entries in /etc/exports using class parameters or the 
nfs_exports::export defined type.  

WARNING: This class will overwrite any existing entry for a given export, it does
not manage individual clients in a given export.

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with nfs_exports](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nfs_exports](#beginning-with-nfs_exports)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)

## Description

Use this to simply manage exports entries without managing everything about NFS.
Do not use this module if you want to preserve existing client entries for a given 
export line in /etc/exports.

## Setup

### Setup Requirements

The file to be managed (typically /etc/exports) must already exist, the module
makes no attempt to create an empty one for you, nor install an nfs server, etc.

### Beginning with nfs_exports

```puppet
nfs_exports::export{ '/data/:
  clients => [{client => 'testvm.example.com', options => ['rw']}],
}
```

## Usage

```puppet
class { '::nfs_exports':
  exportfs => '/opt/bin/exportfs -ra',
  exports => {
    '/data'     => [
      { client => 'testvm.example.com', options => ['rw'] },
      { client => 'roclient.example.com', options => ['ro'] },
    ],
  },
}
```

should produce the following, and then execute '/opt/bin/exportfs -ra'

```text
/data testvm.example.com(rw) roclient.example.com(ro)
```

```puppet
nfs_exports::export { '/data':
  clients => [
    { client => '-', options => ['ro'] },
    { client => 'example.com'},
    { client => 'other.example.com', options => 'rw'},
 ],
}
```

should produce:

```text
/data -ro example.com other.example.com(rw)
```

## Limitations

The module doesn't attempt to validate the client or options part of the configuration.
There are a many ways to specify a client to the exports file including wildcard patterns, etc. so for the sake of time there is no validation.
The module should be able to manage individual entries in an export line without overwriting the whole line, possibly using augeas and a real type instead of a defined type.