require_relative 'guaranteed_file'

module Trackler
  class Description
    def self.for(specification:, track: )
      new(GuaranteedFile.for(specification: specification, track: track, filename: 'description.md'))
    end

    def initialize(description_file)
      @file = description_file
      @content = description_file.content
    end
    private_class_method :new

    def to_s
      @content
    end

    def url
      @file.url
    end

    def exists?
      !@content.empty?
    end
  end
end
