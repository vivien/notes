# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

require "minitest/autorun"
require "notes"

# TODO write a better test suite
class TestNotes < MiniTest::Unit::TestCase
  def setup
    @sample = File.join File.dirname(__FILE__), "sample.c"
  end

  def test_note
    note = Notes::Note.new
    [:tag, :text, :line, :source].each do |method|
      assert note.respond_to?(method)
    end
    note = Notes.scan_file(@sample).first
    assert_equal "//TODO first thing to do\n", note.text
    assert_equal "TODO", note.tag
  end

  def test_module_function_scan
    assert_kind_of Enumerator, Notes.scan("blah")
    assert_equal 0, Notes.scan("").count
    assert_equal 1, Notes.scan("XXX").count
    Notes.scan("XXX") do |note|
      assert_kind_of Notes::Note, note
    end
  end

  def test_module_function_scan_file
    assert_kind_of Enumerator, Notes.scan_file(@sample)
    assert_equal 6, Notes.scan_file(@sample).count
    Notes.scan_file(@sample) do |note|
      assert_kind_of Notes::Note, note
    end
  end

  def test_module_extend
    file = File.new(@sample)
    file.extend Notes
    assert file.respond_to?(:notes)
    assert_kind_of Enumerator, file.notes
    assert_equal 6, file.notes.count
    file.notes do |note|
      assert_kind_of Notes::Note, note
    end
  end

  def test_scanner
    skip
    scanner = Notes::Scanner.new
    scanner.tags = []
    # TODO return an enum when no callback set?
    assert_kind_of Enumerator, scanner.scan("")
    assert_equal 0, scanner.scan("TODO").count
    scanner.tags = ["TODO"]
    assert_equal 1, scanner.scan("TODO").count
    scanner.on_note do |note|
      assert_kind_of Notes::Note, note
      assert_equal "TODO", note.tag
    end
    scanner.scan_file(@sample)
  end

  def test_match
    assert Notes.scan("TODO").any?
    assert !Notes.scan("TODOX").any?
    assert !Notes.scan("XTODO").any?
    assert !Notes.scan("XTODOX").any?
  end

  def test_empty
    assert !Notes.scan("TODO", []).any?
    assert !Notes.scan_file(@sample, []).any?
  end
end
