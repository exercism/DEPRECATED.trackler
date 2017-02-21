require_relative 'test_helper'
require_relative '../lib/trackler'

class TracklerTest < Minitest::Test
  def test_todos
    Trackler.use_fixture_data
    slugs = %w(banana cherry imbe mango)
    assert_equal slugs, Trackler.todos["fake"].map(&:slug)
  end

  def test_problems_does_not_contain_track_specific_problems
    Trackler.use_fixture_data

    assert_nil Trackler.problems.detect { |p| p.slug == "snowflake-only" }
  end

  def test_implementations_does_contain_track_specific_problems
    Trackler.use_fixture_data

    refute_nil Trackler.implementations['snowflake-only']
  end

  def test_todos_does_not_contain_track_specific_problems
    Trackler.use_fixture_data

    assert_empty Trackler.todos['snowflake-only']
  end
end
