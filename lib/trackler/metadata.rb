require_relative 'metadata_file'

module Trackler
  class Metadata
    def self.for(problem:, track: )
      new(MetadataFile.for(problem: problem, track: track))
    end

    attr_accessor :blurb, :source, :source_url

    def initialize(metadata_file)
      @attrs = metadata_file.to_h
      %w(blurb source source_url).each do |attr|
        self.send("#{attr}=".to_sym, @attrs[attr].to_s.strip)
      end
    end

    def exists?
      !@attrs.empty?
    end
  end
end
