# NOTE create a notes/task
task :default => :test

desc 'Run the test suite on Notes'
task :test do
  ruby *%w[-I lib test/test_notes.rb]
end

desc 'Build the gem'
task :gem do
  system *%w[gem build notes.gemspec]
end

desc 'Install the locally built gem'
task :install => :gem do
  system *%w[gem install -l notes --no-ri --no-rdoc]
end

desc 'Grep notes (using the development script)'
task :notes do
  ruby *%[-I lib/ bin/notes --no-{todo,fixme,xxx} --tag NOTE]
end
