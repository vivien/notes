Notes
=====

grep tags in source files

This gem provides a Ruby library and a command line tool to find tags in
source files. The defaults are:

* TODO
* FIXME
* XXX

But custom tags can be found as well.

It's kind of a generic version of the `rake notes` command (only used
for Ruby on Rails applications). It will look for tags recursively in
every given files (or in current directory by default).

Installation
------------

Notes is available on Rubygems.org[http://rubygems.org/gems/notes] and
can be installed with:

    $ [sudo] gem install notes

Command line tool
-----------------

    $ notes [options] [file...]

For details, see the help.

The Notes Library
-----------------

Module functions:

    require 'notes'
    
    Notes.scan_file("foo.c") do |note|
      puts "#{note.tag} found at line #{note.line}!"
    end
    
    Notes.scan("...\nXXX: an urgent note!") do |note|
      putes note.text
    end

Extending the Notes module:

    require 'notes'
    
    file = File.new("foo.c")
    file.extend Notes
    notes = file.notes { |note| puts note.text }

Using the Notes scanner:

    require 'notes'
    
    scan = Notes::Scanner.new
    scan.tags = Notes::TAGS + "FOO"
    scan.on_note do |note|
      puts "found!"
    end
    scan.scan_file("foo.c")
    scan.scan_file("bar.c")

Create your own scanner:

    require 'notes'
    
    class Foo < Notes::Scanner
      attr_reader :notes

      def initialize tags = nil
        super(tags)
        @notes = []
      end
    
      # Called if no action block set. So override it.
      def tag note
        @notes << note
      end
    end

License
-------

That's free for sure! See the LICENSE file.
