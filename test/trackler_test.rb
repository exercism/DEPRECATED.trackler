require_relative 'test_helper'
require_relative '../lib/trackler'

class TracklerTest < Minitest::Test
  def test_todos
    Trackler.use_fixture_data
    slugs = %w(banana cherry mango no-metadata)
    assert_equal slugs, Trackler.todos["fake"].map(&:slug)
  end
end
