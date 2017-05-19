module Trackler
  class GuaranteedFile
    attr_accessor :content

    def self.for(problem:, track:, filename:)
      [TrackFile, CommonFile].detect(-> {NullFile}) do |d|
        d.send(:exists?, problem: problem, track: track, filename: filename)
      end.send(:new, problem: problem, track: track, filename: filename)
    end

    private

    attr_accessor :problem, :track, :filename

    def self.exists?(problem:, track:, filename:)
      File.exists?(location(problem: problem, track: track, filename: filename))
    end
    private_class_method :exists?

    def initialize(problem:, track:, filename:)
      self.problem = problem
      self.track = track
      self.filename = filename
      self.content = File.read(self.class.location(problem: problem, track: track, filename: filename))
    end
    private_class_method :new
  end

  class TrackFile < GuaranteedFile
    def self.location(problem:, track:, filename:)
      File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, '.meta', filename)
    end

    def url
      "#{track.repository}/blob/master/exercises/%s/.meta/#{filename}" % problem.slug
    end
  end

  class CommonFile < GuaranteedFile
    def self.location(problem:, filename:, **_track)
      File.join(problem.root, 'common', 'exercises', problem.slug, filename)
    end

    def url
      "https://github.com/exercism/x-common/blob/master/exercises/%s/#{filename}" % problem.slug
    end
  end

  class NullFile < GuaranteedFile
    def method_missing(*)
      # NOOP
    end

    def respond_to?(*)
      true
    end

    def inspect
      "<null>"
    end

    def exists?
      false
    end

    def content
      ""
    end

    def initialize(*)
      self
    end

    klass = self
    define_method(:class) { klass }
  end
end
