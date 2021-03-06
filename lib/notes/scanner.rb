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
    #   scanner.callback = proc { |note| puts note.file }
    #
    # @see :on_note
    attr_accessor :callback

    # Create a new scanner
    #
    # @example
    #   scan = Notes::Scanner.new(["TODO", "@@@"]) do |note|
    #     puts "#{note.file} contains notes!"
    #   end
    #   
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
      return if tags.empty? || callback.nil?
      rxp = regexp
      source.split("\n").each_with_index do |line, i|
        if rxp =~ line
          callback.call Note.new($1, line, i + 1)
        end
      end
    end

    # Scan a file
    #
    # @example
    #   scanner.scan_file("foo.c")
    def scan_file path
      return if tags.empty? || callback.nil?
      rxp = regexp
      File.open(path, 'r') do |file|
        file.each_with_index do |line, i|
          if rxp =~ line
            callback.call Note.new($1, line, i + 1, path)
          end
        end
      end
    end

    private

    def regexp
      /\b(#{@tags.join('|')})\b/
    end

  end # Scanner
end # Notes
