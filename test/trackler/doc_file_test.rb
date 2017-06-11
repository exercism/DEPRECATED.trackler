require_relative '../test_helper'
require 'trackler'

class DocFileTest < Minitest::Test
  def test_find_orgmode_file
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    file = DocFile.find(basename: 'ABOUT', track_dir: track.dir)

    assert_equal "ABOUT.org", file.name
    expected = "Language Information\n"
    assert_equal expected, file.render
  end

  def test_find_markdown_file
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    file = DocFile.find(basename: 'TESTS', track_dir: track.dir)

    assert_equal "TESTS.md", file.name
    expected = "Running\n![](http://example.org/abc/docs/img/test.jpg)\n"
    assert_equal expected, file.render
  end

  def test_handle_image_paths
    track = Trackler::Track.new('fake', FIXTURE_PATH)

    file = DocFile.find(basename: 'STRAY', track_dir: track.dir)
    expected = "![](/alt/test.jpg)\n"
    assert_equal expected, file.render(image_path: "/alt")

    file = DocFile.find(basename: 'STRAY', track_dir: track.dir)
    expected = "![](/alt/test.jpg)\n"
    assert_equal expected, file.render(image_path: "/alt/")
  end

  def test_do_not_override_full_urls
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    file = DocFile.find(basename: 'TESTS', track_dir: track.dir)

    assert_equal "TESTS.md", file.name
    expected = "Running\n![](http://example.org/abc/docs/img/test.jpg)\n"
    assert_equal expected, file.render(image_path: "/alt")
  end

  def test_handle_unknown_file
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    file = DocFile.find(basename: 'UNKNOWN', track_dir: track.dir)

    assert_equal "UNKNOWN.md", file.name
    assert_equal "", file.render(image_path: "/img")
  end
end
