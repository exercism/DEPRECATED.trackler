paths = Dir[File.expand_path('../trackler/**/*.rb', __FILE__)]
paths.each { |path| require path }

module Trackler
  def self.reset
    @path = nil
    @implementations = nil
    @problems = nil
    @tracks = nil
    @todos = nil
  end

  def self.path
    @path ||= Trackler::Path.root
  end

  def self.use_real_data
    reset
    @path = Trackler::Path.root
  end

  def self.use_fixture_data
    reset
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
        @implementations[implementation.slug] << implementation
      end
    end
    @implementations
  end

  def self.todos
    return @todos if !!@todos

    slugs = problems.map(&:slug)

    @todos = Hash.new { |h, k| h[k] = [] }
    tracks.each do |track|
      todos = slugs - track.slugs
      @todos[track.id] = problems.select { |problem|
        todos.include?(problem.slug)
      }.sort_by { |problem|
        [implementations[problem.slug].count * -1, problem.name]
      }
    end
    @todos
  end
end
