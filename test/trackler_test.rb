require_relative 'test_helper'
require_relative '../lib/trackler'

class TracklerTest < Minitest::Test
  def test_todos
    Trackler.use_fixture_data
    slugs = %w(banana cherry mango)
    assert_equal slugs, Trackler.todos["fake"].map(&:slug)
  end

  def test_implementations
    Trackler.use_fixture_data
    result = Trackler.implementations
    expected = ["dog", "hello-world", "one", "two", "three", "apple", "banana", "cherry"]
    assert_equal expected, result.keys
  end

  def test_implementations_returns_hash_of_array_of_implementations
    Trackler.use_fixture_data
    result = Trackler.implementations
    expected = Trackler::Implementation
    assert result.all? { |k,v| v.first.class == expected }
  end



end
