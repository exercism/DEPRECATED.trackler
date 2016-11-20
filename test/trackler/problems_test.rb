require_relative '../test_helper'
require 'trackler/problem'
require 'trackler/problems'

class ProblemsTest < Minitest::Test
  def test_collection
    problems = Trackler::Problems.new(FIXTURE_PATH)

    # can access it like an array
    slugs = [
      "apple", "banana", "cherry", "dog", "hello-world", "imbe", "mango", "one", "three", "two"
    ]
    assert_equal slugs, problems.map(&:slug)

    # can access it like a hash
    assert_equal "Cherry", problems["cherry"].name

    # handles null problems
    refute problems["no-such-problem"].exists?

    # kind of dirty set operation
    slugs = %w(one two three apple)
    todos = %w(dog hello-world imbe banana cherry mango).sort
    assert_equal todos, problems - slugs
  end
end
