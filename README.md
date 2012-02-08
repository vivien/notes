# Notes

grep tags in source files

This gem provides a command line tool and a Ruby library to find tags in
source code. Defaults tags are *TODO*, *FIXME*, and *XXX*.
Custom tags can be found as well.

It's kind of a generic version of the `rake notes` command,
which is only available in Ruby on Rails applications.

## Command line tool

Usage:

    $ notes [options] [file...]

With no argument, `notes` will search recursively in the current
directory. For details, see `notes --help`.

Examples:

    $ notes
    $ notes foo.h src/
    $ notes --tag @@@
    $ notes --no-{todo,fixme,xxx} --tag FOO

### Convention over configuration

Notes won't filter. `find`, `xargs` are here for you:

    $ find . -name '*.rb' | xargs notes

No custom output. It uses a grep-style display, which makes it easy to
fit your needs. Try:

    $ notes | cut -d: -f3,4-

Or get the list of tagged files in the current directory with:

    $ notes | cut -d: -f1 | sort -u

## Installation

Notes is available on [Rubygems.org](http://rubygems.org/gems/notes) and
can be installed with:

    $ [sudo] gem install notes

## The Notes library

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
    file.notes { |note| puts note.text }

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
