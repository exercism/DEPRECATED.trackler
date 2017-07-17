require_relative '../test_helper'
require 'trackler/implementations'

class ImplementationsTest < Minitest::Test
  def test_collection
    track = Trackler::Track.new('fake', FIXTURE_PATH)
    path = File.join(FIXTURE_PATH, 'tracks', 'fake', 'config.json')
    implementations = Trackler::Implementations.new("[REPO_URL]", track.send(:active_slugs), FIXTURE_PATH, track)

    # can access it like an array
    names = [
      "Hello World", "One", "Two", "Three"
    ]
    assert_equal names, implementations.map(&:name)

    # can access it like a hash
    assert_equal "Hello World", implementations["hello-world"].name

    # handles null implementations
    refute implementations["no-such-implementation"].exists?
  end
end
