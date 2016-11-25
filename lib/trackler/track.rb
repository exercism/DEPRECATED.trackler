require 'json'
require 'pathname'
require 'org-ruby'
require_relative 'file_bundle'

module Trackler
  # Track is a collection of exercises in a given language.
  class Track
    TOPICS = %w(about installation tests learning resources)

    Image = Struct.new(:path) do
      def exists?
        File.exist?(path)
      end

      def type
        File.extname(path).sub('.', '').to_sym
      end
    end

    attr_reader :id, :root, :file_bundle
    def initialize(id, root)
      @id = id
      @root = Pathname.new(root)
      @file_bundle = FileBundle.new(dir.join("global"))
    end

    def exists?
      File.exist?(dir)
    end

    def active?
      !!config["active"]
    end

    def upcoming?
      !active? && problems.length > 0
    end

    def planned?
      !active? && problems.length.zero?
    end

    def implementations
      @implementations ||= Implementations.new(id, repository, active_slugs, root)
    end

    def problems
      @problems ||= implementations.map(&:problem)
    end

    def checklist_issue
      config.fetch("checklist_issue", 1)
    end

    def gitter
      config["gitter"]
    end

    def icon_path
      icon.path if icon.exists?
    end

    def icon
      @icon ||= Image.new(File.join(dir, "img/icon.png"))
    end

    %w(language repository).each do |name|
      define_method name do
        config[name].to_s.strip
      end
    end

    def test_pattern
      if config.key?('test_pattern')
        Regexp.new(config['test_pattern'])
      else
        /test/i
      end
    end

    def docs
      Hash[TOPICS.zip(TOPICS.map { |topic| document_contents(topic) })]
    end

    def img(file_path)
      Image.new(File.join(dir, file_path))
    end

    def doc_format
      default_format = 'md'
      path = File.join(dir, "docs", "*.*")
      most_popular_format(path) || default_format
    end

    def global_zip
      @zip ||= file_bundle.zip
    end

    # Every slug mentioned in the configuration.
    def slugs
      active_slugs + foregone_slugs + deprecated_slugs
    end

    def unimplemented_problems
      Trackler.todos[id]
    end

    private

    # The slugs for the problems that are currently in the track.
    # We deprecated the old array of problem slugs in favor of an array
    # containing richer metadata about a given exercise.
    def active_slugs
      __active_slugs__.empty? ? __active_slugs_deprecated_key__ : __active_slugs__
    end

    def __active_slugs__
      (config["exercises"] || []).map { |ex| ex["slug"] }
    end

    def __active_slugs_deprecated_key__
      config["problems"] || []
    end

    def foregone_slugs
      config["foregone"] || []
    end

    def deprecated_slugs
      config["deprecated"] || []
    end

    def most_popular_format(path)
      formats = Dir.glob(path).map do |filename|
        File.extname(filename).sub(/^\./, '')
      end
      formats.max_by { |format| formats.count(format) }
    end

    def dir
      root.join("tracks", id)
    end

    def config
      @config ||= JSON.parse(File.read(config_filename))
    end

    def config_filename
      File.join(dir, "config.json")
    end

    def document_contents(topic)
      filename = document_filename(topic)
      case filename
      when /\.md$/
        File.read(filename)
      when /\.org$/
        Orgmode::Parser.new(File.read(filename)).to_markdown
      else
        ''
      end
    end

    def document_filename(topic)
      path = File.join(dir, "docs", topic.upcase)
      Dir.glob("%s.*" % path).sort.first
    end

  end
end
