require_relative '../test_helper'
require 'trackler/specification'
require 'trackler/specifications'

class SpecificationsTest < Minitest::Test
  def test_collection
    specifications = Trackler::Specifications.new(FIXTURE_PATH)

    # can access it like a hash
    assert_equal "Cherry", specifications["cherry"].name

    # handles null specifications
    refute specifications["no-such-problem"].exists?

    # kind of dirty set operation
    slugs = %w(one two three apple)
    todos = %w(dog hello-world imbe banana cherry mango).sort
    assert_equal todos, specifications - slugs
  end

  def test_only_valid_specifications
    specifications = Trackler::Specifications.new(FIXTURE_PATH)
    slugs = %w(apple banana cherry dog hello-world imbe mango one three two)
    assert_equal slugs, specifications.map(&:slug)
  end
end
