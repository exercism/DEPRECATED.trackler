module Trackler
  class DescriptionFile
    attr_reader :content

    def self.for(problem:, track:)
      [TrackDescriptionFile, CommonDescriptionFile].detect(-> {NullDescriptionFile}) do |d|
        d.send(:exists?,problem: problem, track: track)
      end.send(:new, problem: problem, track: track)
    end

    def url
      raise
    end

    def to_s
      String(@content)
    end

    private

    attr_accessor :problem, :track

    def self.exists?(problem:, track:)
      File.exists?(location(problem: problem, track: track))
    end
    private_class_method :exists?

    def initialize(problem:, track:)
      self.problem = problem
      self.track = track
      @content = File.read(self.class.location(problem: problem, track: track))
    end
    private_class_method :new
  end

  class TrackDescriptionFile < DescriptionFile
    def self.location(problem:, track:)
      File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'description.md')
    end

    def url
      "#{track.repository}/blob/master/exercises/%s/description.md" % problem.slug
    end
  end

  class CommonDescriptionFile < DescriptionFile
    def self.location(problem:, **_track)
      File.join(problem.root, 'common', 'exercises', problem.slug, 'description.md')
    end

    def url
      "https://github.com/exercism/x-common/blob/master/exercises/%s/description.md" % problem.slug
    end
  end

  class NullDescriptionFile < BasicObject
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

    def to_s
      ""
    end

    def initialize(*)
      self
    end

    klass = self
    define_method(:class) { klass }
  end
end
