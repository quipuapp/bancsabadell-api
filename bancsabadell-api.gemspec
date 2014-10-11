$:.push File.expand_path('../lib', __FILE__)
require 'banc_sabadell/version'

Gem::Specification.new do |s|
  s.name     = 'bancsabadell-api'
  s.version  = BancSabadell::VERSION
  s.authors  = ['Albert Bellonch']
  s.email    = ['albert@getquipu.com']
  s.summary  = 'Ruby client for the official BancSabadell API'
  s.homepage = 'https://getquipu.com'
  s.license  = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
