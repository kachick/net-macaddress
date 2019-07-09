# coding: us-ascii

lib_name = 'net-macaddress'.freeze
require "./lib/net/macaddress/version"

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Utils for MACAddresses}
  gem.summary       = gem.description.dup
  gem.homepage      = "https://github.com/kachick/#{lib_name}"
  gem.license       = 'MIT'
  gem.name          = lib_name
  gem.version       = Net::MACAddress::VERSION.dup

  gem.add_development_dependency 'rspec', '>= 3.8', '< 4'
  gem.add_development_dependency 'yard', '>= 0.9.20', '< 2'

  if RUBY_ENGINE == 'rbx'
    gem.add_dependency 'rubysl', '~> 2.2'
  end

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
