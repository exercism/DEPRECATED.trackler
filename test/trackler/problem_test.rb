require_relative '../test_helper'
require 'trackler'
require 'trackler/problem'

class ProblemTest < Minitest::Test
  def test_existing_problem
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)

    assert problem.exists?, "hello world files not found in the metadata dir"
    assert_equal 'hello-world', problem.slug
    assert_equal 'Hello World', problem.name
    assert_equal 'Oh, hello.', problem.blurb
    assert_equal "* hello\n* hello again\n", problem.description
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', problem.yaml_url
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/description.md', problem.md_url

    assert_equal "## Source\n\nThe internet. [http://example.com](http://example.com)", problem.source_markdown
    assert_equal 'The internet.', problem.source
    assert_equal 'http://example.com', problem.source_url
  end

  def test_json_url
    problem = Trackler::Problem.new('mango', FIXTURE_PATH)
    assert_equal "https://github.com/exercism/x-common/blob/master/exercises/mango/canonical-data.json", problem.json_url

    # missing JSON file
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    assert_equal nil, problem.json_url
  end

  def test_default_location
    problem = Trackler::Problem.new('mango', FIXTURE_PATH)
    assert_equal "## Source\n\nThe mango. [http://example.com](http://example.com)", problem.source_markdown
  end

  def test_source_markdown_no_source
    # in deprecated location
    problem = Trackler::Problem.new('banana', FIXTURE_PATH)
    assert_equal "## Source\n\n[http://example.com](http://example.com)", problem.source_markdown
  end

  def test_no_such_problem
    refute Trackler::Problem.new('no-such-problem', FIXTURE_PATH).exists?
  end

  def test_implementations
    mock_implemnetation = Minitest::Mock.new
    mock_implemnetation.expect( :git_url, 'fake url' )
    mock_implemnetation.expect( :track_id, 'fake track_id' )

    # Temporarily return the format wanted by:
    # exercism.io/app/views/languages/_contribute_exercise.erb
    expected = [{'url' => 'fake url', 'track_id' => 'fake track_id'}]

    Trackler.stub( :implementations, {'apple' => [mock_implemnetation] } ) do
      problem = Trackler::Problem.new('apple', FIXTURE_PATH)
      assert_equal expected, problem.implementations
    end
  end
end
