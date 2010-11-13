# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

module Notes
  class Annotation
    attr_accessor :file, :line, :tag, :text

    def initialize(args)
      @file = args[:file]
      @line = args[:line]
      @tag = args[:tag]
      @text = args[:text]
    end
  end
end
