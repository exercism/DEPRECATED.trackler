require_relative 'null_metadata'

module Trackler
  class Metadata
    def self.for(problem:, track: )
      if File.exists?(File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'metadata.yml'))
        new(File.read(File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'metadata.yml')))
      elsif File.exists?(File.join(problem.root, 'common', 'exercises', problem.slug, 'metadata.yml'))
        new(File.read(File.join(problem.root, 'common', 'exercises', problem.slug, 'metadata.yml')))
      else
        NullMetadata.new
      end
    end

    attr_accessor :blurb, :source, :source_url

    def initialize(raw_metadata)
      yaml = YAML.load(raw_metadata)
      %w(blurb source source_url).each do |attr|
        self.send("#{attr}=".to_sym, yaml[attr].to_s.strip)
      end
    end

    def exists?
      true
    end
  end
end
