# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require "test/unit"
require "notes"
require "tempfile"

class NotesTest < Test::Unit::TestCase
  def setup
    @sample = "#{File.join "..", "test", "data", "sample.c"}"
  end

  def test_new
    notes = AnnotationExtractor.new(@sample)
    assert_equal 5, notes.list.size
    notes.list.each { |a| assert_kind_of AnnotationExtractor::Annotation, a }

    AnnotationExtractor.tags << "FOO"
    notes = AnnotationExtractor.new(@sample)
    assert_equal 6, notes.list.size

    # Test exact text
    assert_equal "first thing to do", notes.list[0].text
    assert_equal "first fixme thing", notes.list[1].text
    assert_equal "second todo thing!", notes.list[2].text
    assert_equal "make it better", notes.list[3].text
    assert_equal "a custom tag", notes.list[4].text
    assert_equal "hello world", notes.list[5].text

    AnnotationExtractor.tags = "OPTIMIZE"
    notes = AnnotationExtractor.new(@sample)
    assert_equal 1, notes.list.size
    assert_equal "make it better", notes.list.first.text

    AnnotationExtractor.tags = "FOO"
    notes = AnnotationExtractor.new(@sample)
    assert_equal 1, notes.list.size
    assert_equal "a custom tag", notes.list.first.text
  end

  def test_get
    notes = AnnotationExtractor.new(@sample)
    assert_equal 3, notes.get("TODO").size
    assert_equal 1, notes.get("FIXME").size
    assert_equal 1, notes.get("OPTIMIZE").size
  end

  def test_write
    tempfile = Tempfile.new("notes").path

    AnnotationExtractor.tags = AnnotationExtractor::TAGS
    notes = AnnotationExtractor.new(@sample)
    notes.write tempfile

    assert_equal 5, File.readlines(tempfile).size

    File.delete tempfile
  end
end
