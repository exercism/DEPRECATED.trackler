module Trackler
  class GuaranteedFile
    attr_accessor :content

    def self.for(specification:, track:, filename:)
      [TrackFile, CommonFile].detect(-> {NullFile}) do |d|
        d.send(:exists?, specification: specification, track: track, filename: filename)
      end.send(:new, specification: specification, track: track, filename: filename)
    end

    private

    attr_accessor :track, :filename, :specification

    def self.exists?(specification:, track:, filename:)
      File.exists?(location(specification: specification, track: track, filename: filename))
    end
    private_class_method :exists?

    def initialize(specification:, track:, filename:)
      self.specification = specification
      self.track = track
      self.filename = filename
      self.content = File.read(self.class.location(specification: specification, track: track, filename: filename))
    end
    private_class_method :new
  end

  class TrackFile < GuaranteedFile
    def self.location(specification:, track:, filename:)
      File.join(specification.root, 'tracks', track.id, 'exercises', specification.slug, '.meta', filename)
    end

    def url
      "#{track.repository}/blob/master/exercises/%s/.meta/#{filename}" % specification.slug
    end
  end

  class CommonFile < GuaranteedFile
    def self.location(specification:, filename:, **_track)
      File.join(specification.root, 'problem-specifications', 'exercises', specification.slug, filename)
    end

    def url
      "https://github.com/exercism/problem-specifications/blob/master/exercises/%s/#{filename}" % specification.slug
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
