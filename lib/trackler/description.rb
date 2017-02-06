require_relative 'description_file'

module Trackler
  class Description
    def self.for(problem:, track: )
      new(DescriptionFile.for(problem: problem, track: track))
    end

    def initialize(description_file)
      @content = description_file.to_s
    end
    private_class_method :new

    def to_s
      @content
    end

    def exists?
      !@content.empty?
    end
  end
end
