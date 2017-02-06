module Trackler
  class DescriptionFile
    attr_reader :content

    def self.for(problem:, track:)
      [TrackDescriptionFile, CommonDescriptionFile].detect(-> {NullDescriptionFile}) do |d|
        d.exists?(problem: problem, track: track)
      end.new(problem: problem, track: track)
    end

    def self.exists?(problem:, track:)
      File.exists?(location(problem: problem, track: track))
    end

    def initialize(problem:, track:)
      @content = File.read(self.class.location(problem: problem, track: track))
    end

    def to_s
      String(@content)
    end
  end

  class TrackDescriptionFile < DescriptionFile
    def self.location(problem:, track:)
      File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'description.md')
    end
  end

  class CommonDescriptionFile < DescriptionFile
    def self.location(problem:, **_track)
      File.join(problem.root, 'common', 'exercises', problem.slug, 'description.md')
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
