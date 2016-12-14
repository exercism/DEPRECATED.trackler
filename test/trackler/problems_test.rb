require_relative '../test_helper'
require 'trackler/problem'
require 'trackler/problems'

class ProblemsTest < Minitest::Test
  def test_collection
    problems = Trackler::Problems.new(FIXTURE_PATH)

    # can access it like a hash
    assert_equal "Cherry", problems["cherry"].name

    # handles null problems
    refute problems["no-such-problem"].exists?

    # kind of dirty set operation
    slugs = %w(one two three apple)
    todos = %w(dog hello-world imbe banana cherry mango track-and-field).sort
    assert_equal todos, problems - slugs
  end

  def test_only_valid_problems
    problems = Trackler::Problems.new(FIXTURE_PATH)
    slugs = %w(apple banana cherry dog hello-world imbe mango one three track-and-field two)
    assert_equal slugs, problems.map(&:slug)
  end
end
