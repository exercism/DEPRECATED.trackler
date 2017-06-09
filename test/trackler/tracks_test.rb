require_relative '../test_helper'
require 'trackler'

module Trackler
  class TracksTest < Minitest::Test
    def test_can_access_it_like_an_array
      tracks = Tracks.new(FIXTURE_PATH)
      assert_kind_of Enumerable, tracks
    end

    def test_fixture_tracks_exist
      tracks = Tracks.new(FIXTURE_PATH)
      # This need not be ALL the fixture tracks.
      ids = %w(animal fake jewels fruit shoes snowflake vehicles)
      assert_empty ids - tracks.map(&:id)
    end

    def test_can_access_it_like_a_hash
      tracks = Tracks.new(FIXTURE_PATH)
      assert tracks['fruit'].exists?
    end

    def test_handles_null_tracks
      tracks = Tracks.new(FIXTURE_PATH)
      refute tracks["no-such-track"].exists?
    end
  end
end
