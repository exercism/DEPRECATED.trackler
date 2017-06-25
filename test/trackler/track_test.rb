require_relative '../test_helper'
require 'trackler'

class TrackTest < Minitest::Test
  def assert_archive_contains(filenames, zip)
    files = []
    Zip::InputStream.open(zip) do |io|
      while (entry = io.get_next_entry)
        files << entry.name
      end
    end
    assert_equal filenames.sort, files.sort
  end

  def test_default_track
    track = Trackler::Track.new('fake', FIXTURE_PATH)

    assert track.exists?, "track 'fake' not found"
    assert track.active?, "track 'fake' inactive"
    assert_equal "Fake", track.language
    assert_equal "https://github.com/exercism/xfake", track.repository
    assert_equal 5, track.checklist_issue
    assert_nil track.gitter

    slugs = %w(hello-world one two three)
    assert_equal slugs, track.implementations.map(&:slug)

    # This is a sanity-check to demonstrate that this fake
    # track actually has both foregone and deprecated problems.
    slugs = %w(hello-world one two three apple dog)
    assert_equal ["apple"], track.send(:foregone_slugs)
    assert_equal ["dog"], track.send(:deprecated_slugs)
    assert_equal slugs, track.send(:slugs)

    # default test pattern
    assert_equal(/test/i, track.test_pattern)
  end

  def test_deprecated_implementations
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    slugs = %w(apple banana cherry)
    assert_equal slugs, track.implementations.map(&:slug)
  end

  def test_implementations
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    slugs = %w(apple banana cherry)
    assert_equal slugs, track.implementations.map(&:slug)
  end

  def test_img
    track = Trackler::Track.new('fake', FIXTURE_PATH)

    img = track.img('img/icon.png')
    assert img.exists?, "track icon fake.png cannot be found in img dir"
    assert_equal :png, img.type
    assert_equal FIXTURE_PATH + "/tracks/fake/img/icon.png", img.path

    img = track.img('docs/img/test.png')
    assert img.exists?, "image test.png cannot be found in docs dir"
    assert_equal :png, img.type
    assert_equal FIXTURE_PATH + "/tracks/fake/docs/img/test.png", img.path

    img = track.img('docs/img/nope.png')
    refute img.exists?, "should not have a nope.png"
  end

  def test_docs
    track = Trackler::Track.new('fake', FIXTURE_PATH)

    expected = OpenStruct.new({
      "about" => "Language Information\n",
      "installation" => "Installing\n![](/docs/img/test.jpg)\n",
      "tests" => "Running\n![](http://example.org/abc/docs/img/test.jpg)\n",
      "learning" => "Learning Fake!\n",
      "resources" => "Fake resources for Fake!\n",
    })
    assert_equal expected, track.docs
  end

  def test_docs_with_unknown_extension
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    assert_equal "", track.docs.resources
  end

  def test_docs_with_alternate_image_path
    track = Trackler::Track.new('fake', FIXTURE_PATH)

    expected = "Installing\n![](/alt/test.jpg)\n"
    assert_equal expected, track.docs(image_path: "/alt").installation
    # handles trailing slash
    assert_equal expected, track.docs(image_path: "/alt/").installation
    # doesn't break absolute URLs
    expected = "Running\n![](http://example.org/abc/docs/img/test.jpg)\n"
    assert_equal expected, track.docs(image_path: "/alt").tests
  end

  def test_docs_accessible_as_object
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    expected = "Language Information\n"
    assert_equal expected, track.docs.about
  end

  def test_docs_also_accessible_as_a_hash
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    expected = "Language Information\n"
    assert_equal expected, track.docs['about']
  end

  def test_doc_format
    assert_equal "org", Trackler::Track.new('fake', FIXTURE_PATH).doc_format
    assert_equal "md", Trackler::Track.new('fruit', FIXTURE_PATH).doc_format
    assert_equal "md", Trackler::Track.new('jewels', FIXTURE_PATH).doc_format # no docs dir
  end

  def test_track_with_gitter_room
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    assert_equal 'xfruit', track.gitter
  end

  def test_track_with_default_checklist_issue
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    assert_equal 1, track.checklist_issue
  end

  def test_custom_test_pattern
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    assert_equal(/\.tst$/, track.test_pattern)
  end

  def test_unknown_track
    refute Trackler::Track.new('nope', FIXTURE_PATH).exists?, "unexpected track 'nope'"
  end

  def test_icon_path_svg
    subject = Trackler::Track.new('fruit', FIXTURE_PATH)
    expected = FIXTURE_PATH + '/tracks/fruit/img/icon.svg'
    assert_equal expected, subject.icon_path
  end

  def test_icon_path_png
    subject = Trackler::Track.new('fake', FIXTURE_PATH)
    expected = FIXTURE_PATH + '/tracks/fake/img/icon.png'
    assert_equal expected, subject.icon_path
  end

  def test_icon_path_nonexisting
    subject = Trackler::Track.new('noicon', FIXTURE_PATH)
    assert_nil subject.icon_path
  end

  def test_global_files
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    files = ["some-vendored-library", "sub-global/other-some-vendor"]
    assert_archive_contains files, track.global_zip
  end

  def test_states
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    assert track.active?
    refute track.upcoming?
    refute track.planned?

    track = Trackler::Track.new('shoes', FIXTURE_PATH)
    refute track.active?
    assert track.upcoming?
    refute track.planned?

    track = Trackler::Track.new('vehicles', FIXTURE_PATH)
    refute track.active?
    refute track.upcoming?
    assert track.planned?
  end

  def test_track_implementations_contains_track_only_problem
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    refute_nil track.implementations.detect {|i| i.slug == "snowflake-only"}
    assert track.implementations.detect {|i| i.slug == "snowflake-only"}.exists?
  end

  def test_track_ignore_pattern_custom
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    assert_equal '[^_]example', track.ignore_pattern
  end

  def test_track_ignore_pattern_default
    mock_config = {}
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    JSON.stub :parse, mock_config do
      assert_equal 'example', track.ignore_pattern
    end
  end

  def test_track_hints
    track = Trackler::Track.new('coins', FIXTURE_PATH)
    expected = "This is the content of the docs/EXERCISE_README_INSERT.md file\n"
    assert_equal expected, track.hints
  end

  def test_track_hints_not_present
    track = Trackler::Track.new('shoes', FIXTURE_PATH)
    expected = ""
    assert_equal expected, track.hints
  end

  def test_problems_deprecated
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    problems = nil
    assert_output nil, /DEPRECATION WARNING/ do
      problems = track.problems
    end
    assert_equal track.implementations, problems
  end
end
