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
      @name ||= slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      @description ||= File.read(filepath(md_path))
    end

    def source_markdown
      body = source.empty? ? "" : "%s" % source
      url = source_url.empty? ? "" : "[%s](%s)" % [source_url, source_url]
      if url.empty? && body.empty?
        ""
      else
        "## Source\n\n" + [body, url].reject(&:empty?).join(" ")
      end
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

    %w(blurb source source_url).each do |name|
      define_method name do
        metadata[name].to_s.strip
      end
    end

    private

    def json_path
      [
        "exercises/%s/canonical-data.json" % slug,
        "%s.json" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def yaml_path
      [
        "exercises/%s/metadata.yml" % slug,
        "%s.yml" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def md_path
      [
        "exercises/%s/description.md" % slug,
        "%s.md" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def repo_url(path)
      "https://github.com/exercism/x-common/blob/master/%s" % path
    end

    def filepath(filename)
      File.join(root, "common", filename)
    end

    def metadata
      @metadata ||= YAML.load(File.read(filepath(yaml_path)))
    end
  end
end
