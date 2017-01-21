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
- Ubuntu >= 14.04

### Cookbook dependencies
- [poise-python](https://github.com/poise/poise-python)

## Attributes

### devpi::server

These attributes are under `node['devpi']['server']`

Attribute|Description|Type|Default
---------|-----------|----|-------
url | Devpi server Url to listen from | String | http://localhost
port | Devpi server port where your boats will arrive | Integer | 3141
home_dir | Devpi server installation directory | String | /home/devpi
data_dir | Devpi server data directory | String | /var/devpi
user | Devpi server user | String | devpi
group | Devpi server group | String | devpi
name | Devpi server package/binary name | String | devpi-server
version | Desired devpi server version to install | String | nil (latest)

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
- [ ] Add Nginx frontend
- [ ] Add mirror configuration
- [ ] Create indexes??

