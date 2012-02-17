# NOTE Notes::Note undefined if we just require notes/scanner
module Notes
  class Scanner

    # The array of tags to look for
    #
    # @example
    #   scanner.tags << "FOO"
    #
    # @return [Array]
    #   the tags list
    attr_accessor :tags

    # The block to execute when a note is found
    #
    # @example
    #   scanner.callback = proc { |note| puts note.source }
    #
    # @see :on_note
    attr_accessor :callback

    # Create a new scanner
    #
    # @example
    #   scan = Notes::Scanner.new(["TODO", "@@@"]) do |note|
    #     puts "#{note.source} contains notes!"
    #   end
    #   
    #   # NOTE best place for this example?
    #   class NotesCounter < Notes::Scanner
    #     attr_reader :notes
    #
    #     def initialize tags = nil
    #       super(tags)
    #       @notes = []
    #       @callback = proc { |note| @notes << note }
    #     end
    #   end
    def initialize tags = nil, &block
      @tags = tags || TAGS.dup
      @callback = block
    end

    # Define the callback to execute when a note is given
    #
    # @example
    #   scanner.on_note do |note|
    #     puts note.text
    #   end
    #
    # @see :callback=
    def on_note &block
      @callback = block
    end

    # Scan a source string
    #
    # @example
    #   scanner.scan("...//XXX urgent fix!")
    def scan source
      return if tags.empty?
      source.split("\n").each_with_index do |line, i|
        if line =~ regexp
          @callback.call Note.new($1, line, i + 1)
        end
      end
    end

    # Scan a file
    #
    # @example
    #   scanner.scan_file("foo.c")
    def scan_file path
      return if tags.empty?
      file = File.open(path, 'r')
      file.each_with_index do |line, i|
        if line =~ regexp
          @callback.call Note.new($1, line, i + 1, path)
        end
      end
      file.close
    end

    private

    def regexp
      /\b(#{@tags.join('|')})\b/
    end

  end # Scanner
end # Notes
