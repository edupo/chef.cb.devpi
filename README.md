# devpio status [![Build Status](https://travis-ci.org/edupo/chef.cb.devpi.svg?branch=master)](https://travis-ci.org/edupo/chef.cb.devpi)

## Decription
Installs and configures a devpi server initializing it as a service for your
most appropriate init script or daemon.

> There are other cookbooks you may take a look into before considering this
> one as it is __under development__.
> The aim of this cookbook is create a simple and readable cookbook _minimizing
> complexities_ and _maximizing quality_. 

## Usage
Add `recipe[devpi::server]`

## Requirements

### Platforms
- Debian >= 8
- Ubuntu >= 14.04

### Cookbook dependencies
- [poise-python](https://github.com/poise/poise-python)

## Attributes

These attributes are under `node['devpi']['server']`

Attribute|Description|Type|Default
---------|-----------|----|-------
host | Devpi server Url to listen from | String | http://localhost
port | Devpi server port where your boats will arrive | Integer | 3141
data_dir | Devpi server data directory | String | /var/devpi

## Resources

### devpi_server

This resource installs a complete devpi server on the node. 

#### Actions

* :create
* :remove

#### Properties

Property|Description|Type|Default
--------|-----------|----|-------
user | Devpi service system user | String | devpi
group | Devpi service system group | String | devpi
home_dir | Location where devpi binaries and virtualenv is installed | String | /home/#{user}
data_dir | Data storage location | String | undefined (/var/devpi)
host | IP to host the service | String | localhost (remember that you need to set this to 0.0.0.0 if you want to use devpi server in your network)
port | Service's port | Integer | 3141
version | Devpi server package version | String | undefined (latest)
package | Devpi server package name | String | devpi-server

### devpi_client

#### Actions

* :create
* :remove

#### Properties

Property|Description|Type|Default
--------|-----------|----|-------
version | Devpi client package version | String | undefined (latest)
package | Devpi client package name | String | devpi-server

## Contributing

Please use Github issues/pull reuqests. You may use the provided .kitchen files
for testing with Vagrant or Docker. This repository is TravisCI-ready so please
make sure your branch is working before pull requesting.

## Lincense

This software is licensed under [Apache License, Version
2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Contributors

* edupo (contact@eduardolezcano.com)

## TODO

- [x] Install devpi server
- [x] Configure service for systemd and init.d
- [x] Add devpi client
- [ ] Create users
- [ ] Create indexes
- [ ] Add mirror configuration
- [ ] Add Nginx frontend
