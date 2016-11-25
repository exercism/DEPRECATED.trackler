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
      !!md_path && !!yaml_path
    end

    def name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      @description ||= File.read(common_metadata_path(md_path))
    end

    def source_markdown
      text = [source, markdown_link(source_url)].reject(&:empty?).join(" ")
      text.empty? ? text : "## Source\n\n#{text}"
    end

    def md_url
      repo_url(md_path)
    end

    def json_url
      repo_url(json_path) if !!json_path
    end

    def yaml_url
      repo_url(yaml_path)
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

    def json_path
      [
        "exercises/%s/canonical-data.json" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def yaml_path
      [
        "exercises/%s/metadata.yml" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def md_path
      [
        "exercises/%s/description.md" % slug,
      ].find { |filename| File.exist?(common_metadata_path(filename)) }
    end

    def repo_url(path)
      "https://github.com/exercism/x-common/blob/master/#{path}"
    end

    def metadata
      @metadata ||= YAML.load(File.read(common_metadata_path(yaml_path)))
    end

    def common_metadata_path(path)
      File.join(root, "common", path)
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
