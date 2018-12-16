require "#{File.dirname(__FILE__)}/lib/notes/version"

Gem::Specification.new do |spec|
  spec.name = 'notes'
  spec.author = 'Vivien Didelot'
  spec.email = 'vivien.didelot@gmail.com'
  spec.version = Notes::VERSION
  spec.summary = 'Stupidly grep tags in source code.'
  spec.require_path = 'lib'
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables << 'notes'
  spec.add_dependency 'paint', '>= 2.0.3'
  spec.add_development_dependency 'minitest', '>= 5.11.3'
  spec.add_development_dependency 'rake', '>= 12.3.2'
end
