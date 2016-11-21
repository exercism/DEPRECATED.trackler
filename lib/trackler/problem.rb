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
      description_exists? && yaml_exists?
    end

    def name
      @name ||= slug_to_name
    end

    def description
      @description ||= load_description
    end

    def source_markdown
      text = [source, markdown_link(source_url)].reject(&:empty?).join(" ")
      text.empty? ? text : "## Source\n\n#{text}"
    end

    def md_url
      repo_url(md_path)
    end

    def json_url
      repo_url(json_path) if json_path
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

    def description_exists?
      !md_path.nil?
    end

    def yaml_exists?
      !yaml_path.nil?
    end

    def slug_to_name
      slug.split('-').map(&:capitalize).join(' ')
    end

    def json_path
      [
        "exercises/%s/canonical-data.json" % slug,
        "%s.json" % slug,
      ].find { |path| common_metadata_exists_for?(path) }
    end

    def yaml_path
      [
        "exercises/%s/metadata.yml" % slug,
        "%s.yml" % slug,
      ].find { |path| common_metadata_exists_for?(path) }
    end

    def md_path
      [
        "exercises/%s/description.md" % slug,
        "%s.md" % slug,
      ].find { |path| common_metadata_exists_for?(path) }
    end

    def repo_url(path)
      "https://github.com/exercism/x-common/blob/master/%s" % path
    end

    def metadata
      @metadata ||= load_yaml
    end

    def common_metadata_path(path)
      File.join(root, "common", path)
    end

    def common_metadata_exists_for?(path)
      File.exist?(common_metadata_path(path))
    end

    def load_description
      File.read(common_metadata_path(md_path))
    end

    def load_yaml
      YAML.load(File.read(common_metadata_path(yaml_path)))
    end

    def markdown_link(url)
      url.empty? ? url : format("[%s](%s)", url, url)
    end
  end
end
