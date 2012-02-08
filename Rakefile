task :default => :test

desc 'Run the test suite on Notes'
task :test do
  ruby *%w[-I lib test/notes_test.rb]
end

desc 'Build the gem'
task :gem do
  system *%w[gem build notes.gemspec]
end

desc 'Install the locally built gem'
task :install => :gem do
  system *%w[gem install -l notes --no-ri --no-rdoc]
end
