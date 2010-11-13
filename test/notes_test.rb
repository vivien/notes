# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require "test/unit"
require "notes"
require "tempfile"

include Notes

class NotesTest < Test::Unit::TestCase
  def setup
    @sample = "#{File.join "..", "test", "data", "sample.c"}"
  end

  def test_new
    notes = Reader.new(@sample)
    assert_equal 5, notes.list.size
    notes.list.each { |a| assert_kind_of Notes::Annotation, a }

    Reader.tags << "FOO"
    notes = Reader.new(@sample)
    assert_equal 6, notes.list.size

    Reader.tags = "OPTIMIZE"
    notes = Reader.new(@sample)
    assert_equal 1, notes.list.size
    assert_equal "make it better", notes.list.first.text

    Reader.tags = "FOO"
    notes = Reader.new(@sample)
    assert_equal 1, notes.list.size
    assert_equal "a custom tag", notes.list.first.text
  end

  def test_get
    notes = Reader.new(@sample)
    assert_equal 3, notes.get("TODO").size
    assert_equal 1, notes.get("FIXME").size
    assert_equal 1, notes.get("OPTIMIZE").size
  end

  def test_write
    tempfile = Tempfile.new("notes").path

    Reader.tags = Reader::TAGS
    notes = Reader.new(@sample)
    notes.write tempfile

    assert_equal 5, File.readlines(tempfile).size

    File.delete tempfile
  end
end
