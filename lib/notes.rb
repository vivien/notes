# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require 'coderay'
require 'coderay/helpers/file_type'
require 'coderay/encoders/annotation_extractor'

# TODO should grep on all text tokens if @lang == :text
# TODO add a "split comment" or "inline" option and enable it if @lang == :text

module Notes
  VERSION = "2.0"
  DEFAULT_TAGS = [:todo, :fixme, :optimize, :note]

  # Scan some code. Should give the corresponding language
  # (see CodeRay supported languages)
  #
  #   Notes.scan("a = 1 + 1", :ruby, :todo) { |text| puts text }
  def self.scan(code, lang, *annotations, &block)
    # block.nil? and return enum_for(__method__, code, lang, *annotations)
    scanner = Scanner.new
    scanner.annotations = annotations.flatten unless annotations.empty?
    scanner.on_annotation(&block) unless block.nil?
    scanner.scan(code, lang)
  end

  # Scan a file for the given annotations.
  #
  #   Notes.scan_file("test/dummy.rb") do |text, type, line|
  #     puts "#{todo}:#{line}: #{text}"
  #   end
  #
  #   Notes.scan_file("test/dummy.rb", :fixme) { |text| puts text }
  def self.scan_file(filename, *annotations, &block)
    scanner = Scanner.new
    scanner.annotations = annotations.flatten unless annotations.empty?
    scanner.on_annotation(&block) unless block.nil?
    scanner.scan_file(filename)
  end

  def self.file_type(filename)
    CodeRay::FileType.fetch filename, :text, true
  end

  class Scanner
    def initialize
      @encoder = CodeRay::Encoders::AnnotationExtractor.new
      self.annotations = [:all]
    end

    def annotations
      @encoder.annotations
    end

    # Set an array of annotations to search
    # A Symbol corresponds to a standard annotation while a String is a custom one.
    # Defaults annotations are:
    # :todo     => "TODO"
    # :fixme    => "FIXME"
    # :optimize => "OPTIMIZE"
    # :note     => "NOTE"
    #
    # Special Symbol :all means every default annotation and :none means none of them.
    #
    #   scan.annotations = [:all, "@@@"] # => [:todo, :fixme, :optimize, :notes, "@@@"]
    def annotations=(an)
      tmp = []
      an.each do |a|
        case a
        when :all   then tmp.concat(DEFAULT_TAGS)
        when :none  then tmp.clear
        when Symbol then DEFAULT_TAGS.include?(a) and tmp << a
        when String then tmp << a
        else puts "invalid annotation #{a}"
        end
      end
      @encoder.annotations = tmp.uniq
    end

    # Set the action to do when a annotation is found
    #
    #   scan.on_annotation do |text, kind, line|
    #     puts "#{kind}:#{line}: #{text}"
    #   end
    def on_annotation(&block)
      @encoder.set_callback(&block)
    end
    #alias set_callback on_annotation

    # Scan directly some code, need to specify the language
    # (see CodeRay supported languages)
    def scan(code, lang)
      @encoder.encode(code, lang)
    end

    # Scan a given file
    def scan_file(filename)
      lang = Notes.file_type(filename)
      code = File.read(filename)
      scan(code, lang)
    end
  end
end
