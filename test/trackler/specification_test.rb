require_relative '../test_helper'
require 'trackler/specification'
require 'trackler/track'

class SpecificationTest < Minitest::Test
  def test_existing_specification
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert specification.exists?, "hello world files not found in the metadata dir"
  end

  def test_slug
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'hello-world', specification.slug
  end

  def test_name
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'Hello World', specification.name
  end

  def test_blurb
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'Oh, hello.', specification.blurb
  end

  def test_description
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal "* hello\n* hello again\n", specification.description
  end

  def test_metadata_url
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/metadata.yml', specification.metadata_url
  end

  def test_description_url
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'https://github.com/exercism/x-common/blob/master/exercises/hello-world/description.md', specification.description_url
  end

  def test_source_markdown
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal "## Source\n\nThe internet. [http://example.com](http://example.com)", specification.source_markdown
  end

  def test_source
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'The internet.', specification.source
  end

  def test_source_url
    specification = Trackler::Specification.new('hello-world', FIXTURE_PATH)
    assert_equal 'http://example.com', specification.source_url
  end

  def test_no_source_url_in_metadata
    specification = Trackler::Specification.new('apple', FIXTURE_PATH)
    assert_equal '', specification.source_url
  end

  def test_canonical_data_url
    specification = Trackler::Specification.new('mango', FIXTURE_PATH)
    assert_equal "https://github.com/exercism/x-common/blob/master/exercises/mango/canonical-data.json", specification.canonical_data_url
  end

  def test_track_with_no_canonical_data
    specification = Trackler::Specification.new('banana', FIXTURE_PATH)
    assert_nil specification.canonical_data_url
  end

  def test_specification_with_no_metadata_yml
    refute Trackler::Specification.new('no-metadata', FIXTURE_PATH).exists?
  end

  def test_default_location
    specification = Trackler::Specification.new('mango', FIXTURE_PATH)
    assert_equal "## Source\n\nThe mango. [http://example.com](http://example.com)", specification.source_markdown
  end

  def test_source_markdown_in_deprecated_location
    specification = Trackler::Specification.new('banana', FIXTURE_PATH)
    assert_equal "## Source\n\n[http://example.com](http://example.com)", specification.source_markdown
  end

  def test_no_such_specification
    refute Trackler::Specification.new('no-such-specification', FIXTURE_PATH).exists?
  end

  def test_source_markdown_empty
    specification = Trackler::Specification.new('cherry', FIXTURE_PATH)
    assert_equal '', specification.source_markdown
  end

  def test_specification_which_is_not_deprecated
    specification = Trackler::Specification.new('apple', FIXTURE_PATH)
    refute specification.deprecated?
  end

  def test_specification_which_has_been_deprecated
    specification = Trackler::Specification.new('fish', FIXTURE_PATH)
    assert specification.deprecated?
  end

  def test_specification_active?
    specification = Trackler::Specification.new('apple', FIXTURE_PATH)
    assert specification.active?
  end

  def test_specification_which_not_active_because_it_is_deprecated
    specification = Trackler::Specification.new('fish', FIXTURE_PATH)
    refute specification.active?
  end

  def test_specification_which_not_active_because_it_does_not_exist
    specification = Trackler::Specification.new('no-such-specification', FIXTURE_PATH)
    refute specification.active?
  end

  def test_description_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "Special snowflakes are _special_\n", specification.description
  end

  def test_blurb_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "This exercise only exists in snowflake", specification.blurb
  end

  def test_source_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "Special snowflake.", specification.source
  end

  def test_source_url_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "http://snowflake.com", specification.source_url
  end

  def test_metadata_url_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "https://example.com/exercism/xsnowflake/blob/master/exercises/snowflake-only/.meta/metadata.yml", specification.metadata_url
  end

  def test_canonical_data_url_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_nil specification.canonical_data_url
  end

  def test_description_url_of_specification_that_exists_in_single_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    specification = Trackler::Specification.new('snowflake-only', FIXTURE_PATH, track)

    assert_equal "https://example.com/exercism/xsnowflake/blob/master/exercises/snowflake-only/.meta/description.md", specification.description_url
  end
end
