require_relative '../test_helper'
require 'trackler/track'
require 'trackler/problem'
require 'trackler/metadata_file'

class MetadataFileTest < Minitest::Test
  def test_url_when_the_file_exists_in_the_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('snowflake-only', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_equal subject.url, "https://example.com/exercism/xsnowflake/blob/master/exercises/snowflake-only/metadata.yml"
  end

  def test_url_when_the_file_exists_only_in_common
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_equal subject.url, "https://github.com/exercism/x-common/blob/master/exercises/apple/metadata.yml"
  end

  def test_url_when_no_metadata_file_exists
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('no-metadata', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_nil subject.url
  end

  def test_to_h_when_the_file_exists_in_the_track
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('snowflake-only', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_equal subject.to_h, {"blurb"=>"This exercise only exists in snowflake", "source"=>"Special snowflake.", "source_url"=>"http://snowflake.com"}
  end

  def test_to_h_when_the_file_exists_only_in_common
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('apple', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_equal subject.to_h, {"blurb"=>"This is apple.", "source"=>"The internet."}
  end

  def test_to_h_when_no_metadata_file_exists
    track = Trackler::Track.new('snowflake', FIXTURE_PATH)
    problem = Trackler::Problem.new('no-metadata', FIXTURE_PATH, track)
    subject = Trackler::MetadataFile.for(problem: problem, track: track)

    assert_equal subject.to_h, {}
  end
end
