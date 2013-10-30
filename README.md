REQUIREMENTS
============

Platform
--------

Currently tested on Ubuntu 10.10. If you get it working on another platform (or
it doesn't work on your platform of choice), open an issue.

Quickstart
----------

Define at least the following attributes:

* `node[:daemontools][:install_method]` - "package" or "source". The former is recommended.
* `node[:zeromq][:src_version]` - string, "2.1.7" recommended


Cookbooks
---------

- build-essential
- zeromq
- daemontools

ATTRIBUTES
==========

All attributes are named under the `mongrel2` keyspace. The attributes
specified in the cookbook are used to setup the default config file.

* `node[:mongrel2][:src_version]` - default version to download
* `node[:mongrel2][:src_mirror]` - full download URL
* `node[:mongrel2][:checksum]` - checksum of src_mirror
* `node[:mongrel2][:chroot]` - directory to chroot mongrel2 in
* `node[:mongrel2][:uuid]` - UUID of the mongrel2 server
* `node[:mongrel2][:name]` - name of the mongrel2 server
* `node[:mongrel2][:hostname]` - hostname to use by default
* `node[:mongrel2][:port]` - port to listen on

RECIPES
=======

default
-------

Installs mongrel2, creates all the required directories, compiles the
configuration and starts the service

LICENSE AND AUTHOR
==================

Author:: Thomas Rampelberg (<thomas@saunter.org>)

Copyright 2011, Thomas Rampelberg

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


