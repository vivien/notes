Gem::Specification.new do |spec|
  spec.name = 'notes'
  spec.author = 'Vivien Didelot'
  spec.email = 'vivien.didelot@gmail.com'
  spec.version = '0.0.2'
  spec.summary = 'A Ruby gem to grep annotations in source files.'
  spec.require_path = 'lib'
  spec.files = Dir['lib/**/*']
  spec.files << Dir['test/**/*']
  spec.files << 'README.rdoc'
  spec.files << 'CHANGELOG.rdoc'
  spec.files << 'LICENSE'
  spec.executables << 'notes'
  spec.add_dependency 'rak', '>= 1.0'
  spec.add_dependency 'rainbow', '>= 1.1'
end
