# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

# Useless, but informs that rak should be installed.
require 'rubygems'
require 'rak'

class AnnotationExtractor
  VERSION = "0.0.1"

  # An annotation class.
  class Annotation
    attr_accessor :file, :line, :tag, :text

    # Instanciate a new Annotation from a hash.
    def initialize(args)
      @file = args[:file]
      @line = args[:line]
      @tag = args[:tag]
      @text = args[:text]
    end
  end

  # Default tags list
  TAGS = ["TODO", "FIXME", "OPTIMIZE"]

  # Trick not to use @@tags class variable, but works the same way.
  # Custom tags can be added with AnnotationExtractor.tags << "FOO".
  @tags = TAGS.clone
  class << self
    attr_reader :tags
    def tags=(tags)
      @tags = tags.is_a?(Array) ? tags : [tags]
    end
  end

  # The list of all notes.
  attr_reader :list

  # Instanciate a new extractor for the given target files.
  def initialize(source = Dir.pwd)
    @source = [].push(source).flatten
    @list = Array.new

    extract
  end

  # Get annotation with tag 'tag' from the list.
  def get(tag)
    @list.find_all { |a| a.tag == tag }
  end

  # Write all annotations to the file 'file'.
  def write(file)
    longest_tag = @list.max { |a, b| a.tag.size <=> b.tag.size }.tag.size

    File.open(file, 'w') do |f|
      @list.each do |a|
        f.write(sprintf(" * [%-#{longest_tag}s] %s (%s): %s\n",
                        a.tag, a.file, a.line, a.text))
      end
    end
  end

  private

  # Extract annotations.
  def extract
    tags = self.class.tags.join("|")
    suffix = "\s?:?" # Allowed annotation suffix.
    source = @source.join(" ")

    # Because of different rak versions,
    # rak system call outputs are not similar.
    if `rak --version` =~ /rak (\d\.\d)/
      rak_version = $1
    else
      raise "Can't get rak version"
    end

    # 0.9 is the current rak version from rubygems.
    # 1.1 is the current rak version from the github repo.
    if rak_version == "1.1"
      regex = /^(.*):(\d*):.*(#{tags})#{suffix}(.*)$/
    else
      regex = /^([^\s]+)\s+(\d+)\|.*(#{tags})#{suffix}(.*)$/
    end

    out = `rak '(#{tags})#{suffix}\s+' #{source}`.strip

    @list = out.split("\n").map do |l|
      if l =~ regex
        Annotation.new({
          :file => $1,
          :line => $2.to_i,
          :tag => $3,
          :text => $4.strip
        })
      else
        # Just for a debug purpose
        raise "notes: does not match regexp => \"#{l}\""
      end
    end
  end
end
