require_relative '../test_helper'
require 'trackler/problem'
require 'trackler/implementation'
require 'trackler/implementations'

class ImplementationsTest < Minitest::Test
  def test_collection
    path = File.join(FIXTURE_PATH, 'tracks', 'fake', 'config.json')
    slugs = JSON.parse(File.read(path))["exercises"].map { |ex| ex["slug"] }
    implementations = Trackler::Implementations.new('fake', "[REPO_URL]", slugs, FIXTURE_PATH)

    # can access it like an array
    names = [
      "Hello World", "One", "Two", "Three"
    ]
    assert_equal names, implementations.map {|implementation|
      implementation.problem.name
    }

    # can access it like a hash
    assert_equal "Hello World", implementations["hello-world"].problem.name

    # handles null implementations
    refute implementations["no-such-implementation"].exists?
  end
end
