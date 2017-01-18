require_relative '../test_helper'
require 'trackler/problem'

class MetadataTest < Minitest::Test
  def test_blurb
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    metadata = Trackler::Metadata.for_problem(problem: problem)
    assert_equal 'Oh, hello.', metadata.blurb
  end

  def test_source
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    metadata = Trackler::Metadata.for_problem(problem: problem)
    assert_equal 'The internet.', metadata.source
  end

  def test_source_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    metadata = Trackler::Metadata.for_problem(problem: problem)
    assert_equal 'http://example.com', metadata.source_url
  end

  def test_metadata_url
    problem = Trackler::Problem.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', problem.metadata_url
  end

  def test_problem_with_no_metadata_yml
    problem = Trackler::Problem.new('no-metadata', FIXTURE_PATH)
    metadata = Trackler::Metadata.for_problem(problem: problem)
    refute metadata.exists?
  end
end
