require 'yaml'

module Trackler
  # Problem is a language-independent definition of an exercise.
  class Problem
    attr_reader :slug, :root
    def initialize(slug, root)
      @slug = slug
      @root = root
      @file_root = File.join(root, 'common', 'exercises', self.slug)
      @repo_root = "https://github.com/exercism/x-common/blob/master/exercises/%s/" % self.slug
    end

    def exists?
      !!description && !!metadata
    end

    def deprecated?
      @deprecated ||= File.exists?(file_path(deprecation_file_name))
    end

    def active?
      exists? && !deprecated?
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      return @description unless @description.nil?
      filename = file_path(description_file_name)
      if File.exists?(filename)
        @description = File.read(filename)
      end
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
      repo_url(canonical_data_file_name) if File.exists?(file_path(canonical_data_file_name))
    end

    def metadata_url
      repo_url(metadata_file_name)
    end

    def blurb
      metadata['blurb'].to_s.strip
    end

    def source
      metadata['source'].to_s.strip
    end

    def source_url
      metadata['source_url'].to_s.strip
    end

    private

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

    def file_path(filename)
      File.join(@file_root, filename)
    end

    def metadata
      return @metadata unless @metadata.nil?
      filename = file_path(metadata_file_name)
      if File.exists?(filename)
        @metadata = YAML.load(File.read(filename))
      end
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
