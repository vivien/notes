require 'notes/version'
require 'notes/scanner'

module Notes

  # Default tags to grep in source code.
  # They are *TODO*, *FIXME*, and *XXX*.
  TAGS = %w[TODO FIXME XXX]

  # The Note class. This is basically an object with accessors to four attributes:
  # * tag: Tag the line is marked with;
  # * text: The line of text containing the tag;
  # * line: The line number;
  # * source: The filename of the input source.
  Note = Struct.new(:tag, :text, :line, :source)

  # Scan a source string
  #
  # @example
  #   Notes.scan("...\nXXX fix this asap!") do |note|
  #     puts note.text
  #   end
  #
  # @param [String] source
  #   input source to scan
  #
  # @params [Array] tags
  #   tags to look for
  #   if nil, tags will be the defaults (TODO, FIXME, XXX)
  #
  # @params [Proc] block
  #   callback to execute when a note is found
  #
  # @return [Enumerator]
  #   an enumerator on notes when no block is given
  def self.scan(source, tags = nil, &block)
    block.nil? and return enum_for(__method__, source, tags, &block)
    scanner = Scanner.new(tags, &block)
    scanner.scan(source)
  end

  # Scan a file
  #
  # @example
  #   Notes.scan_file("src/foo.c") do |note|
  #     puts note.text
  #   end
  #   
  #   Notes.scan_file("bar.hs", ['@@@']) do |note|
  #     puts "File to fix: #{note.source}!"
  #   end
  #
  # @param [String] filename
  #   name of the file to scan
  #
  # @params [Array] tags
  #   tags to look for
  #   if nil, tags will be the defaults (TODO, FIXME, XXX)
  #
  # @params [Proc] block
  #   callback to execute when a note is found
  #
  # @return [Enumerator]
  #   an enumerator on notes when no block is given
  def self.scan_file(file, tags = nil, &block)
    block.nil? and return enum_for(__method__, file, tags, &block)
    scanner = Scanner.new(tags, &block)
    scanner.scan_file(file)
  end

  # Add a :notes method to an object
  #
  # @example
  #   file = File.new("foo.c")
  #   file.extend Notes
  #   file.notes do |note|
  #     puts note.text
  #   end
  #
  # @params [Array] tags
  #   tags to look for
  #   if nil, tags will be the defaults (TODO, FIXME, XXX)
  #
  # @params [Proc] block
  #   callback to execute when a note is found
  #
  # @return [Enumerator]
  #   an enumerator on notes when no block is given
  def notes(tags = nil, &block)
    block.nil? and return enum_for(__method__, tags, &block)
    scanner = Scanner.new(tags, &block)
    source = (self.respond_to? :read) ? self.read : self.to_s
    scanner.scan(source)
  end

end # Notes
