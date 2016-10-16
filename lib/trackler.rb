paths = Dir[File.expand_path('../trackler/**/*.rb', __FILE__)]
paths.each { |path| require path }

module Trackler
  def self.path
    @path ||= Trackler::Path.root
  end

  def self.use_real_data
    @path = Trackler::Path.root
  end

  def self.use_fixture_data
    @path = Trackler::Path.fixtures
  end

  def self.problems
    @problems ||= Problems.new(path)
  end

  def self.tracks
    @tracks ||= Tracks.new(path)
  end

  def self.implementations
    return @implementations if !!@implementations

    @implementations = Hash.new { |h, k| h[k] = [] }
    tracks.each do |track|
      track.implementations.each do |implementation|
        @implementations[implementation.problem.slug] << implementation
      end
    end
    @implementations
  end
end
