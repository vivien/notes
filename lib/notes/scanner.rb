module Notes
  class Scanner

    attr_accessor :tags, :action

    # TODO doc
    def initialize tags = nil, &block
      @tags = tags || TAGS.dup
      @action = block || proc { |note| tag(note) }
    end

    # TODO doc
    def on_note &block
      @action = block
    end

    # TODO doc
    def scan source
      return if tags.empty?
      source.split("\n").each_with_index do |line, i|
        if line =~ regexp
          @action.call Note.new($1, line, i + 1)
        end
      end
    end

    # TODO doc
    def scan_file path
      return if tags.empty?
      file = File.open(path, 'r')
      file.each_with_index do |line, i|
        if line =~ regexp
          @action.call Note.new($1, line, i + 1, path)
        end
      end
      file.close
    end

    # TODO doc
    def tag note
      puts "#{note.type} on line #{note.line}: #{note.text.strip}"
    end

    private

    def regexp
      /\b(#{@tags.join('|')})\b/
    end

  end # Scanner
end # Notes
