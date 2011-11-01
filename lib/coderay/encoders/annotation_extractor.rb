module CodeRay
  module Encoders
    class AnnotationExtractor < Encoder
      register_for :annotation_extractor

      DEFAULT_TAGS = {
        :todo     => "TODO",
        :fixme    => "FIXME",
        :optimize => "OPTIMIZE",
        :note     => "NOTE"
      }

      attr_accessor :annotations
      #attr_writer :callback
      attr_reader :notes

      protected
      def setup options
        super

        @notes = []
        @number_of_lines = 0
      end

      def finish options
        #@notes.each_slice(3) { |text, kind, line| puts "#{kind}:#{line}: #{text}" }
        #puts @number_of_lines
      end

      public
      def initialize options = {}
        super

        # TODO put @notes, @number_of_lines, @annotations, @callback in DEFAULT_OPTIONS not to overwrite initialize()
        @notes = []          # maybe useless as its called in setup()
        @number_of_lines = 0 # maybe useless as its called in setup()

        @annotations = DEFAULT_TAGS.keys
        @callback = Proc.new { |text, kind, line| @notes.concat([text, kind, line]) }
      end

      def token content, kind
        return unless content.is_a?(String)
        starting_line = @number_of_lines + 1
        @number_of_lines += content.count(?\n)
        return unless kind == :comment
        type, text = parse_comment(content)
        annotation(text, type, starting_line) unless type.nil?
      end

      def annotation text, type, line
        @callback.call(text, type, line)
      end

      def set_callback(&block)
        @callback = block
      end

      private
      def parse_comment comment
        @annotations.each do |a|
          if a.is_a? Symbol
            type = a
            pattern = DEFAULT_TAGS[a]
          else
            type = :custom
            pattern = a
          end
          if comment.include?(pattern)
            # TODO comment = clean_annotation(comment, pattern)
            return [type, comment]
          end
        end
        return nil
      end

      def clean_annotation text, pattern
        text
      end
    end
  end
end
