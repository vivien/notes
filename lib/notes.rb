# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require 'notes/version'
require 'notes/scanner'

module Notes

  # Default tags to grep in source code.
  TAGS = %w[TODO FIXME XXX]

  Note = Struct.new(:tag, :text, :line, :source)

  # TODO doc
  def self.scan(source, tags = nil, &block)
    block.nil? and return enum_for(__method__, source, tags, &block)
    scanner = Scanner.new(tags, &block)
    scanner.scan(source)
  end

  # TODO doc
  def self.scan_file(file, tags = nil, &block)
    block.nil? and return enum_for(__method__, file, tags, &block)
    scanner = Scanner.new(tags, &block)
    scanner.scan_file(file)
  end

  # TODO doc
  def notes(tags = nil, &block)
    block.nil? and return enum_for(__method__, tags, &block)
    scanner = Scanner.new(tags, &block)
    source = (self.respond_to? :read) ? self.read : self.to_s
    scanner.scan(source)
  end

end # Notes
