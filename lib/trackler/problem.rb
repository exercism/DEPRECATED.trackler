require 'yaml'

module Trackler
  # Problem is a language-independent definition of an exercise.
  class Problem
    attr_reader :slug, :root
    def initialize(slug, root)
      @slug = slug
      @root = root
    end

    def exists?
      !!description_path && !!metadata_path
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      @description ||= File.read(common_metadata_path(description_path))
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
      repo_url(description_path)
    end

    def canonical_data_url
      repo_url(canonical_data_path) if !!canonical_data_path
    end

    def metadata_url
      repo_url(metadata_path)
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

    def canonical_data_path
      [
        "exercises/%s/canonical-data.json" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def metadata_path
      [
        "exercises/%s/metadata.yml" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def description_path
      [
        "exercises/%s/description.md" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def repo_url(path)
      "https://github.com/exercism/x-common/blob/master/#{path}"
    end

    def metadata
      @metadata ||= YAML.load(File.read(common_metadata_path(metadata_path)))
    end

    def common_metadata_path(path)
      File.join(root, "common", path)
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
