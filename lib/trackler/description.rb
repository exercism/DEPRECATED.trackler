require_relative 'null_description'

module Trackler
  class Description
    def self.for(problem:, track: )
      if File.exists?(File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'description.md'))
        new(File.read(File.join(problem.root, 'tracks', track.id, 'exercises', problem.slug, 'description.md')))
      elsif File.exists?(File.join(problem.root, 'common', 'exercises', problem.slug, 'description.md'))
        new(File.read(File.join(problem.root, 'common', 'exercises', problem.slug, 'description.md')))
      else
        NullDescription.new
      end
    end

    attr_reader :content

    def initialize(content)
      @content = content
    end

    def exists?
      true
    end
  end
end
