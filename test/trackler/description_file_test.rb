require_relative '../test_helper'
require 'trackler/track'
require 'trackler/problem'
require 'trackler/description_file'

class DescriptionFileTest < Minitest::Test
  def test_url_when_the_file_exists_in_the_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('snowflake-only', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_equal subject.url, "https://example.com/exercism/xsnowflake/blob/master/exercises/snowflake-only/description.md"
  end

  def test_url_when_the_file_exists_only_in_common
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_equal subject.url, "https://github.com/exercism/x-common/blob/master/exercises/apple/description.md"
  end

  def test_url_when_no_description_file_exists
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('no-description', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_nil subject.url
  end

  def test_to_s_when_the_file_exists_in_the_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('snowflake-only', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_equal subject.to_s, "Special snowflakes are _special_\n"
  end

  def test_to_s_when_the_file_exists_only_in_common
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_equal subject.to_s, "* apple\n* apple again\n"
  end

  def test_to_s_when_no_metadata_file_exists
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('no-description', FIXTURE_PATH, track)
    subject = Trackler::DescriptionFile.for(problem: problem, track: track)

    assert_equal subject.to_s, ""
  end
end
