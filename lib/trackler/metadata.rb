require_relative 'guaranteed_file'

module Trackler
  class Metadata
    def self.for(problem:, track: )
      new(GuaranteedFile.for(problem: problem, track: track, filename: 'metadata.yml'))
    end

    attr_accessor :blurb, :source, :source_url

    def initialize(metadata_file)
      @file = metadata_file
      @attrs = YAML.load(@file.content) || {}
      %w(blurb source source_url).each do |attr|
        self.send("#{attr}=".to_sym, @attrs[attr].to_s.strip)
      end
    end

    def url
      @file.url
    end

    def exists?
      !@attrs.empty?
    end
  end
end
