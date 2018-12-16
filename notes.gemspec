require "#{File.dirname(__FILE__)}/lib/notes/version"

Gem::Specification.new do |spec|
  spec.name = 'notes'
  spec.author = 'Vivien Didelot'
  spec.email = 'vivien.didelot@gmail.com'
  spec.version = Notes::VERSION
  spec.summary = 'Stupidly grep tags in source code.'
  spec.require_path = 'lib'
  spec.files = ['lib/notes.rb', 'lib/notes/scanner.rb', 'lib/notes/version.rb']
  spec.files << 'README.rdoc'
  spec.files << 'CHANGELOG.rdoc'
  spec.files << 'LICENSE'
  spec.executables << 'notes'
  spec.add_dependency 'paint', '>= 2.0.3'
  spec.add_development_dependency 'minitest', '>= 5.11.3'
  spec.add_development_dependency 'rake', '>= 12.3.2'
end
