require_relative '../test_helper'
require 'trackler/problem'
require 'trackler/implementation'

class ImplementationTest < Minitest::Test
  def test_zip
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new("fake", "repo.url", problem, FIXTURE_PATH)
    # Our archive is not binary identically reproducable :(
    archive = implementation.zip
    assert_instance_of StringIO, archive
    expected_files = ['hello_test.ext', 'world_test.ext', 'README.md']
    assert_equal expected_files, archive_filenames(implementation.zip)
  end

  def test_implementation_with_extra_files
    problem = Trackler::Problem.new('one', FIXTURE_PATH)
    implementation = Trackler::Implementation.new("fake", "repo.url", problem, FIXTURE_PATH)

    expected = {
      "Fakefile" => "Autorun fake code\n",
      "one_test.ext" => "assert 'one'\n",

      # includes dotfiles
      ".dot" => "dot\n",

      # includes files in subdirectory
      "sub/src/stubfile.ext" => "stub\n",

      # contains implementation-specific hint, but not language-specific hint
      "README.md" => "# One\n\nThis is one.\n\n* one\n* one again\n\n* one hint\n* one more hint\n\n## Source\n\nThe internet. [http://example.com](http://example.com)\n\n## Submitting Incomplete Problems\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"
    }
    assert_equal expected, implementation.files
  end

  def test_implementation_in_subdirectory
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new('fruit', "repo.url", problem, FIXTURE_PATH)
    assert_equal "repo.url/tree/master/exercises/apple", implementation.git_url
    assert_match Regexp.new('exercises[\\/]apple'), implementation.exercise_dir

    expected = {
      "apple.ext" => "an apple a day keeps the doctor away\n",
      "apple.tst" => "assert 'apple'\n",
      "README.md" => "# Apple\n\nThis is apple.\n\n* apple\n* apple again\n\nThe SETUP.md file is deprecated, and exercises/TRACK_HINTS.md should be used.\n\n## Source\n\nThe internet.\n\n## Submitting Incomplete Problems\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"
    }
    assert_equal expected, implementation.files
  end

  def test_language_and_implementation_specific_readme
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    implementation = Trackler::Implementation.new('fruit', "repo.url", problem, FIXTURE_PATH)

    expected = "# Banana\n\nThis is banana.\n\n* banana\n* banana again\n\n* banana specific hints.\n* a hint\n* another hint\n\nThe SETUP.md file is deprecated, and exercises/TRACK_HINTS.md should be used.\n\n## Source\n\n[http://example.com](http://example.com)\n\n## Submitting Incomplete Problems\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"

    assert_equal expected, implementation.readme
  end

  def test_symlinked_file
    problem = Trackler::Problem.new('fish', FIXTURE_PATH)
    implementation = Trackler::Implementation.new('animal', "repo.url", problem, FIXTURE_PATH)

    expected = "This should get included in fish.\n"
    assert_equal expected, implementation.files['included-via-symlink.txt']
  end

  def test_missing_implementation
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new("fake", "repo.url", problem, FIXTURE_PATH)
    refute implementation.exists?, "Not expecting apple to be implemented for track TRACK_ID"
  end

  def test_override_implementation_files
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new("fake", "repo.url", problem, FIXTURE_PATH)
    files = { "filename" => "contents" }
    implementation.files = files
    assert_equal files, implementation.files
  end

  def test_ignores_example_files
    track_id = 'fruit'
    problem = Trackler::Problem.new('imbe', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track_id, "repo.url", problem, FIXTURE_PATH)
    expected = ['imbe.txt', 'README.md']
    assert_equal expected, implementation.files.keys
  end

  def test_readme_has_empty_string_for_track_hint_when_setup_file_does_not_exist
    track_id = 'fake'
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track_id, "repo.url", problem, FIXTURE_PATH)

    expected = "# Apple\n\nThis is apple.\n\n* apple\n* apple again\n\n## Source\n\nThe internet.\n\n## Submitting Incomplete Problems\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"
    assert_equal expected, implementation.readme
  end

  def test_readme_uses_track_hint_in_precedence_of_setup
    track_id = 'animal'
    problem = Trackler::Problem.new('dog', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track_id, "repo.url", problem, FIXTURE_PATH)

    assert_match /This is the content of the track hints file/, implementation.readme
  end

  def test_readme_uses_setup_when_track_hints_is_missing
    track_id = 'fruit'
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track_id, "repo.url", problem, FIXTURE_PATH)

    assert_match %r(The SETUP.md file is deprecated, and exercises/TRACK_HINTS.md should be used.), implementation.readme
  end

  def test_readme_uses_track_hint_instead_of_setup
    track_id = 'jewels'
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track_id, "repo.url", problem, FIXTURE_PATH)

    assert_match /This is the content of the track hints file/, implementation.readme
  end

  private

  def archive_filenames(zip)
    files = []
    Zip::InputStream.open(zip) do |io|
      while (entry = io.get_next_entry)
        files << entry.name
      end
    end
    files
  end
end
