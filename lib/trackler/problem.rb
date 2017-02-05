require 'yaml'
require_relative 'metadata'
require_relative 'description'
require_relative 'null_track'

module Trackler
  # Problem is a language-independent definition of an exercise.
  class Problem
    attr_reader :slug, :root, :metadata
    def initialize(slug, root, track = NullTrack.new)
      @slug = slug
      @root = root
      @file_root = File.join(root, 'common', 'exercises', self.slug)
      @repo_root = "https://github.com/exercism/x-common/blob/master/exercises/%s/" % self.slug

      @metadata = Metadata.for(problem: self, track: track)
      self.description_object = Description.for(problem: self, track: track)

      if track.exists?
        @track_repo_root = "#{track.repository}/blob/master/exercises/%s/" % self.slug
      end
    end

    def exists?
      description_object.exists? && metadata.exists?
    end

    def deprecated?
      @deprecated ||= File.exists?(file_path(deprecation_file_name, @file_root))
    end

    def active?
      exists? && !deprecated?
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      description_object.content
    end

    def source_markdown
      text = [source, markdown_link(source_url)].reject(&:empty?).join(" ")
      text.empty? ? text : "## Source\n\n#{text}"
    end

    ######
    # Deprecated methods
    # TODO: remove external references to these methods.
    # found in: x-api
    # NOT in: exercism.io, cli
    # Anywhere else we need to look?
    # Should this output a warning or raise an error?
    def md_url
      description_url
    end

    def json_url
      canonical_data_url
    end

    def yaml_url
      metadata_url
    end
    # End deprecated methods
    ######

    def description_url
      repo_url(description_file_name)
    end

    def canonical_data_url
      repo_url(canonical_data_file_name) if File.exists?(file_path(canonical_data_file_name, @file_root))
    end

    def metadata_url
      repo_url(metadata_file_name)
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
      if @track_repo_root
        @track_repo_root
      else
        @repo_root
      end + filename
    end

    def file_path(filename, root = @file_root)
      File.join(root, filename)
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
