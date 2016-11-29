require_relative '../test_helper'
require 'trackler/problem'

class ProblemTest < Minitest::Test
  def test_existing_problem
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert problem.exists?, "hello world files not found in the metadata dir"
  end

  def test_slug
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'hello-world', problem.slug
  end

  def test_name
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'Hello World', problem.name
  end

  def test_blurb
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'Oh, hello.', problem.blurb
  end

  def test_description
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal "* hello\n* hello again\n", problem.description
  end

  def test_metadata_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', problem.metadata_url
  end

  def test_deprecated_method_yaml_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', problem.yaml_url
  end

  def test_description_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/description.md', problem.description_url
  end

  def test_deprecated_method_md_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/description.md', problem.md_url
  end

  def test_source_markdown
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal "## Source\n\nThe internet. [http://example.com](http://example.com)", problem.source_markdown
  end

  def test_source
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'The internet.', problem.source
  end

  def test_source_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'http://example.com', problem.source_url
  end

  def test_no_source_url_in_metadata
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    assert_equal '', problem.source_url
  end

  def test_canonical_data_url
    problem = Trackler::Problem.new('mango', FIXTURE_PATH)
    assert_equal "https://github.com/exercism/x-common/blob/master/exercises/mango/canonical-data.json", problem.canonical_data_url
  end

  def test_deprecated_method_json_url
    problem = Trackler::Problem.new('mango', FIXTURE_PATH)
    assert_equal "https://github.com/exercism/x-common/blob/master/exercises/mango/canonical-data.json", problem.json_url
  end

  def test_track_with_no_canonical_data
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    assert_equal nil, problem.canonical_data_url
  end

  def test_problem_with_no_metadata_yml
    refute Trackler::Problem.new('no-metadata', FIXTURE_PATH).exists?
  end

  def test_default_location
    problem = Trackler::Problem.new('mango', FIXTURE_PATH)
    assert_equal "## Source\n\nThe mango. [http://example.com](http://example.com)", problem.source_markdown
  end

  def test_source_markdown_in_deprecated_location
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    assert_equal "## Source\n\n[http://example.com](http://example.com)", problem.source_markdown
  end

  def test_no_such_problem
    refute Trackler::Problem.new('no-such-problem', FIXTURE_PATH).exists?
  end

  def test_source_markdown_empty
    problem = Trackler::Problem.new('cherry', FIXTURE_PATH)
    assert_equal '', problem.source_markdown
  end

  def test_problem_which_is_not_deprecated
    problem = Trackler::Problem.new('apple', FIXTURE_PATH)
    refute problem.deprecated?
  end

  def test_problem_which_has_been_deprecated
    problem = Trackler::Problem.new('fish', FIXTURE_PATH)
    assert problem.deprecated?
  end
end
