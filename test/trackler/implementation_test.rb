require_relative '../test_helper'
require 'trackler/track'
require 'trackler/problem'
require 'trackler/implementation'

class ImplementationTest < Minitest::Test
  def test_implementation_implements_the_same_methods_that_problem_does
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    missing_methods = problem.public_methods - implementation.public_methods
    assert_equal [], missing_methods
  end

  def test_zip
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    # Our archive is not binary identically reproducible :(
    archive = implementation.zip
    assert_instance_of StringIO, archive
    expected_files = ['hello_test.ext', 'world_test.ext', 'README.md']
    assert_equal expected_files, archive_filenames(implementation.zip)
  end

  def test_implementation_with_extra_files
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('one', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = {
      "Fakefile" => "Autorun fake code\n",
      "one_test.ext" => "assert 'one'\n",

      # includes dotfiles
      ".dot" => "dot\n",

      # includes files in subdirectory
      "sub/src/stubfile.ext" => "stub\n",

      # contains implementation-specific hint, but not language-specific hint
      "README.md" => "# One\n\n* one\n* one again\n\n* one hint\n* one more hint\n\n## Source\n\nThe internet. [http://example.com](http://example.com)\n\n## Submitting Incomplete Solutions\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"
    }
    assert_equal expected, implementation.files
  end

  def test_language_and_implementation_specific_readme
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = "# Banana\n\n* banana\n* banana again\n\n* banana specific hints.\n* a hint\n* another hint\n\nThe SETUP.md file is deprecated, and exercises/TRACK_HINTS.md should be used.\n\n## Source\n\n[http://example.com](http://example.com)\n\n## Submitting Incomplete Solutions\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"

    assert_equal expected, implementation.readme
  end

  def test_symlinked_file
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    problem = Trackler::Problem.new('fish', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = "This should get included in fish.\n"
    assert_equal expected, implementation.files['included-via-symlink.txt']
  end

  def test_missing_implementation
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    refute implementation.exists?, "Not expecting apple to be implemented for track TRACK_ID"
  end

  def test_implementation_dup_files
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    original = Trackler::Implementation.new(track, problem)

    # Ensure @files exists before `dup`ing
    assert_instance_of Hash, original.files

    duplicate = original.dup

    refute_equal original.files.object_id, duplicate.files.object_id
  end

  def test_ignores_example_files
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    problem = Trackler::Problem.new('imbe', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = ['imbe.txt', 'README.md']
    assert_equal expected, implementation.files.keys
  end

  def test_never_ignores_explicit_matches_to_configured_test_pattern_regex
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    problem = Trackler::Problem.new('dog', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = ["a_dog.animal", "a_dog_2.animal", "a_test_example_for.animal", "README.md"]
    assert_equal expected, implementation.files.keys
  end

  def test_readme_has_empty_string_for_track_hint_when_setup_file_does_not_exist
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    expected = "# Apple\n\n* apple\n* apple again\n\n## Source\n\nThe internet.\n\n## Submitting Incomplete Solutions\nIt's possible to submit an incomplete solution so you can see how others have completed the exercise.\n\n"
    assert_equal expected, implementation.readme
  end

  def test_readme_uses_track_hint_in_precedence_of_setup
    track = Trackler::Track.new('animal', FIXTURE_PATH)
    problem = Trackler::Problem.new('dog', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    assert_match /This is the content of the track hints file/, implementation.readme
  end

  def test_readme_uses_setup_when_track_hints_is_missing
    track = Trackler::Track.new('fruit', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    assert_match %r{The SETUP.md file is deprecated, and exercises/TRACK_HINTS.md should be used.}, implementation.readme
  end

  def test_readme_uses_track_hint_instead_of_setup
    track = Trackler::Track.new('jewels', FIXTURE_PATH)
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    implementation = Trackler::Implementation.new(track, problem)

    assert_match /This is the content of the track hints file/, implementation.readme
  end

  def test_git_url
    mock_track = OpenStruct.new(repository: '[repository url]')
    mock_problem = OpenStruct.new(slug: 'slug')
    implementation = Trackler::Implementation.new(mock_track, mock_problem)

    assert_equal '[repository url]/tree/master/exercises/slug', implementation.git_url
  end

  def test_language
    expected_language = 'Expected Language'
    mock_track = OpenStruct.new(repository: '[repository url]', language: expected_language)
    mock_problem = OpenStruct.new(slug: 'slug')
    implementation = Trackler::Implementation.new(mock_track, mock_problem)

    assert_equal expected_language, implementation.language
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
