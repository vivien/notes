# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require "test/unit"
require "notes"
require "tempfile"

class Jhead_test < Test::Unit::TestCase
  def setup
    sample = "#{File.join "..", "test", "data", "sample.c"}"
    @reader = Notes::Reader.new sample
  end

  def test_find
    @reader.find
    assert_equal 5, @reader.list.size
    @reader.list.each { |a| assert_kind_of Notes::Annotation, a }

    @reader.find "OPTIMIZE"
    assert_equal 1, @reader.list.size
    assert_equal "make it better", @reader.list.first.text


    @reader.find "FOO"
    assert_equal 1, @reader.list.size
    assert_equal "a custom tag", @reader.list.first.text
  end

  def test_get
    @reader.find
    assert_equal 3, @reader.get("TODO").size
    assert_equal 1, @reader.get("FIXME").size
    assert_equal 1, @reader.get("OPTIMIZE").size
  end

  def test_write
    tempfile = Tempfile.new("notes").path
    @reader.find
    @reader.write tempfile

    assert_equal 5, File.readlines(tempfile).size

    File.delete tempfile
  end
end
