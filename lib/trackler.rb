paths = Dir[File.expand_path('../trackler/**/*.rb', __FILE__)]
paths.each { |path| require path }

module Trackler
  def self.root
    File.expand_path("../../", __FILE__)
  end

  def self.problems
    @problems ||= Problems.new(root)
  end

  def self.tracks
    @tracks ||= Tracks.new(root)
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
