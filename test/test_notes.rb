# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require "minitest/autorun"
require "notes"

class TestNotes < MiniTest::Unit::TestCase
  def setup
    @sample = File.join File.dirname(__FILE__), "..", "test", "sample.c"
  end

  def test_module_functions
    assert_kind_of Enumerator, Notes.scan("blah")
    assert_kind_of Enumerator, Notes.scan_file(@sample)
    assert_equal 0, Notes.scan("").count
    assert_equal 1, Notes.scan("XXX").count
    assert_equal 6, Notes.scan_file(@sample).count
  end

  def test_module_extend
    file = File.new(@sample)
    file.extend Notes
    assert file.respond_to?(:notes)
    assert_kind_of Enumerator, file.notes
    assert_equal 6, file.notes.count
  end

  def test_note
    Notes.scan_file(@sample) do |note|
      assert_kind_of Notes::Note, note
    end
    note = Notes.scan_file(@sample)
    assert_equal "//TODO first thing to do\n", note.first.text
    assert_equal "TODO", note.first.tag
  end

  def test_match
    assert Notes.scan("TODO").any?
    assert !Notes.scan("TODOX").any?
    assert !Notes.scan("XTODO").any?
    assert !Notes.scan("XTODOX").any?
  end
end
