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
      !!md && !!yaml
    end

    def name
      @name ||= slug.split('-').map(&:capitalize).join(' ')
    end

    def description
      @description ||= File.read(filepath(md))
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
      repo_url(md)
    end

    def json_url
      repo_url(json) if !!json
    end

    def yaml_url
      repo_url(yaml)
    end

    %w(blurb source source_url).each do |name|
      define_method name do
        metadata[name].to_s.strip
      end
    end

    # Used by exercism.io/app/views/languages/_contribute_exercise.erb
    def readme_url
      md_url
    end

    def test_suite_url
      "fixme: #{caller.first}"
    end

    #TODO: Complete implementation
    #TODO: Rename to test_data_url
    def data
      test_suite_url
    end

    def implementations
      # TODO: Accessing Trackler directly here is bad.
      implementations = Trackler.implementations[slug]

      # Format for exercism.io/app/views/languages/_contribute_exercise.erb
      # TODO: update _contribute_exercise.erb to use the implemenation object.
      implementations.map do |implementation|
        { 'url' => implementation.git_url, 'track_id' => implementation.track_id }
      end
    end

    private

    def json
      [
        "exercises/%s/canonical-data.json" % slug,
        "%s.json" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def yaml
      [
        "exercises/%s/metadata.yml" % slug,
        "%s.yml" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def md
      [
        "exercises/%s/description.md" % slug,
        "%s.md" % slug,
      ].find { |path| File.exist?(filepath(path)) }
    end

    def repo_url(path)
      "https://github.com/exercism/x-common/blob/master/%s" % path
    end

    def filepath(f)
      File.join(root, "common", f)
    end

    def metadata
      @metadata ||= YAML.load(File.read(filepath(yaml)))
    end
  end
end
