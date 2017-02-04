name 'devpio'
maintainer 'Eduardo Lezcano'
maintainer_email 'contact@eduardolezcano.com'
license 'apachev2'
description 'Installs/Configures devpi server and client'
long_description 'Devpi is a Pypi caching mirror which works with pip
and easy_install.'
version '0.2.0'

depends 'poise-python', '~> 1.5.1'

%w(ubuntu debian).each do |os|
  supports os
end

issues_url 'https://github.com/edupo/chef.cb.devpi/issues' \
  if respond_to?(:issues_url)
source_url 'https://github.com/edupo/chef.cb.devpi' if respond_to?(:source_url)
