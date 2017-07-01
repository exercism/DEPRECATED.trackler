require 'yaml'
require_relative 'metadata'
require_relative 'description'
require_relative 'null_track'

module Trackler
  # Specification is a language-independent definition of a problem to solve.
  class Specification
    attr_reader :slug, :root, :metadata
    def initialize(slug, root, track = NullTrack.new)
      @slug = slug
      @root = root
      @file_root = File.join(root, 'problem-specifications', 'exercises', self.slug)
      @repo_root = "https://github.com/exercism/problem-specifications/blob/master/exercises/%s/" % self.slug

      @metadata = Metadata.for(specification: self, track: track)
      self.description_object = Description.for(specification: self, track: track)
    end

    def exists?
      description_object.exists? && metadata.exists?
    end

    def deprecated?
      @deprecated ||= File.exist?(file_path(deprecation_file_name, @file_root))
    end

    def active?
      exists? && !deprecated?
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      description_object.to_s
    end

    def source_markdown
      text = [source, markdown_link(source_url)].reject(&:empty?).join(" ")
      text.empty? ? text : "## Source\n\n#{text}"
    end

    def description_url
      description_object.url
    end

    def canonical_data_url
      repo_url(canonical_data_file_name) if File.exist?(file_path(canonical_data_file_name, @file_root))
    end

    def metadata_url
      metadata.url
    end

    def blurb
      metadata.blurb
    end

    def source
      metadata.source
    end

    def source_url
      metadata.source_url
    end

    private

    attr_accessor :description_object

    def canonical_data_file_name
      "canonical-data.json"
    end

    def description_file_name
      "description.md"
    end

    def metadata_file_name
      "metadata.yml"
    end

    def deprecation_file_name
      ".deprecated"
    end

    def repo_url(filename)
      @repo_root + filename
    end

    def file_path(filename, root = @file_root)
      File.join(root, filename)
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
