lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

if RUBY_VERSION < '2.0.0'
  require 'sensu-plugins-turbine'
else
  require_relative 'lib/sensu-plugins-turbine'
end

Gem::Specification.new do |s|
  s.name          = 'sensu-plugins-turbine'
  s.version       = SensuPluginsTurbine::Version::VER_STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['mickfeech and contributors']
  s.date          = Date.today.to_s
  s.email         = ['cmcfee@kent.edu']
  s.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.homepage      = 'https://github.com/mickfeech/sensu-plugins-turbine'
  s.summary       = 'This provides functionality to check turbine streams.'
  s.description   = 'Plugins to provide functionality to check metrics from the turbine stream for Sensu, a monitoring framework'
  s.license       = 'MIT'
  s.has_rdoc      = false
  s.require_paths = ['lib']
  s.files         = Dir['lib/**/*.rb']
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'
  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'em-http-request'
  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 10.5'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rubocop',                   '~> 0.37'
  s.add_development_dependency 'rspec',                     '~> 3.4'
  s.add_development_dependency 'yard'                       '~> 0.9.11'
end
